{ pkgs, configDir, inputs, ... }:
let
  nvimDir = configDir + "/nvim";
  copilot-lualine = pkgs.vimUtils.buildVimPlugin {
    name = "copilot-lualine";
    src = inputs.copilot-lualine;
  };
  copilot-chat-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "CopilotChat";
    src = inputs.copilot-chat-nvim;
  };

  themes = with pkgs.vimPlugins; [ edge everforest sonokai ];
  completion = with pkgs.vimPlugins; [
    cmp-buffer
    cmp-cmdline-history
    cmp-latex-symbols
    cmp-nvim-lsp
    cmp-nvim-lsp-document-symbol
    cmp-nvim-lsp-signature-help
    cmp-path
    cmp-treesitter
    cmp-rg
    cmp_luasnip
    nvim-cmp
    cmp-fish
    cmp-zsh
    copilot-cmp
    cmp-tmux
    # copilot-vim
    copilot-lua
  ];
  git = with pkgs.vimPlugins; [
    committia
    diffview-nvim
    git-blame-nvim
    git-messenger-vim
    gitsigns-nvim
    neogit
  ];
  tree-sitter = with pkgs.vimPlugins; [
    nvim-treesitter-context
    nvim-treesitter-textobjects
    nvim-treesitter.withAllGrammars
    nvim-ts-context-commentstring
    rainbow-delimiters-nvim
    playground
  ];
  telescope = with pkgs.vimPlugins; [
    telescope-fzf-native-nvim
    telescope-nvim
    telescope-project-nvim
    telescope-sg
    telescope-symbols-nvim
    telescope-undo-nvim
  ];
  lsp = with pkgs.vimPlugins; [
    lsp-inlayhints-nvim
    lsp_extensions-nvim
    lspkind-nvim
    null-ls-nvim
    nvim-lspconfig
    pkgs.nodejs
  ];
  ui = with pkgs.vimPlugins; [
    aerial-nvim
    copilot-lualine
    lualine-nvim
    nvim-lightbulb
    nvim-notify
    nvim-scrollbar
    nvim-web-devicons
    trouble-nvim
    true-zen-nvim
    zen-mode-nvim
  ];
  nix = with pkgs.vimPlugins; [
    direnv-vim
    nix-develop-nvim
    vim-nix
    vim-nixhash
  ];
  snippets = with pkgs.vimPlugins; [ friendly-snippets luasnip ];
  neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withRuby = true;
    withPython3 = true;
    withNodeJs = true;
    extraPackages = [ ];
    extraLuaPackages = ps: [ (ps.callPackage ./tiktoken-lua.nix { }) ];
    plugins = with pkgs.vimPlugins;
      [
        copilot-chat-nvim
        better-escape-nvim
        ccc-nvim
        comment-nvim
        todo-comments-nvim
        glance-nvim
        goto-preview
        harpoon2
        leap-nvim
        neo-tree-nvim
        neogen
        neoscroll-nvim
        nvim-autopairs
        nvim-surround
        ssr-nvim
        plenary-nvim
        ron-vim
        toggleterm-nvim
        undotree
        vim-floaterm
        vimtex
        zoxide-vim
        {
          plugin = sqlite-lua;
          config = ''
            lua << EOF
            require("init")
            EOF
            let g:sqlite_clib_path = '${pkgs.sqlite.out}/lib/libsqlite3.so'
          '';
        }
      ] ++ completion ++ git ++ lsp ++ nix ++ snippets ++ telescope
      # ++ testing
      ++ themes ++ tree-sitter ++ ui;
  };
in {
  programs.neovim = neovim;

  xdg.configFile = {
    "nvim/" = {
      source = nvimDir;
      recursive = true;
    };
  };

  programs.bash.shellAliases = {
    vimdiff = "nvim -d";
    vim = "nvim";
    vi = "nvim";
  };

  programs.fish = {
    shellAliases = {
      vimdiff = "nvim -d";
      vim = "nvim";
      vi = "nvim";
    };
  };

  programs.zsh.shellAliases = {
    vimdiff = "nvim -d";
    vim = "nvim";
    vi = "nvim";
  };
}
