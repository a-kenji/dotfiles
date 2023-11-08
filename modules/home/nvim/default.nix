{
  pkgs,
  configDir,
  inputs,
  ...
}: let
  nvimDir = configDir + "/nvim";
  themes = with pkgs.vimPlugins; [
    awesome-vim-colorschemes
    edge
    everforest
    sonokai
  ];
  completion = with pkgs.vimPlugins; [
    cmp-buffer
    cmp-cmdline-history
    cmp-latex-symbols
    cmp-nvim-lsp
    cmp-nvim-lsp-document-symbol
    cmp-nvim-lsp-signature-help
    cmp-path
    # cmp-git ??
    cmp-treesitter
    cmp-rg
    cmp_luasnip
    nvim-cmp
    cmp-fish
    cmp-zsh
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
    telescope-frecency-nvim
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
  ];
  ui = with pkgs.vimPlugins; [
    aerial-nvim
    nvim-lightbulb
    nvim-web-devicons
    trouble-nvim
    zen-mode-nvim
    true-zen-nvim
    lualine-nvim
    nvim-notify
    nvim-scrollbar
    nvim-code-action-menu
  ];
  nix = with pkgs.vimPlugins; [
    direnv-vim
    nix-develop-nvim
    vim-nix
    vim-nixhash
  ];
  snippets = with pkgs.vimPlugins; [
    friendly-snippets
    luasnip
  ];
  testing = with pkgs.vimPlugins; [
    nvim-coverage
    neotest
    neotest-rust
    nvim-dap
    nvim-dap-ui
    nvim-dap-virtual-text
    vim-test
  ];
  neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withRuby = false;
    withPython3 = true;
    withNodeJs = true;
    extraPackages = [];
    plugins = with pkgs.vimPlugins;
      [
        # auto-session
        better-escape-nvim
        ccc-nvim
        comment-nvim
        todo-comments-nvim
        glance-nvim
        goto-preview
        harpoon
        leap-nvim
        nvim-spectre
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
      ]
      ++ completion
      ++ git
      ++ lsp
      ++ nix
      ++ snippets
      ++ telescope
      ++ testing
      ++ themes
      ++ tree-sitter
      ++ ui;
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
