{
  pkgs,
  configDir,
  inputs,
  ...
}: let
  nvimDir = configDir + "/nvim";
  themes = with pkgs.vimPlugins; [
    edge
    sonokai
    everforest
    awesome-vim-colorschemes
  ];
  completion = with pkgs.vimPlugins; [
    cmp-path
    cmp-buffer
    nvim-cmp
    cmp_luasnip
    cmp-nvim-lsp
    cmp-latex-symbols
    cmp-nvim-lsp-document-symbol
    cmp-cmdline-history
    cmp-rg
  ];
  git = with pkgs.vimPlugins; [
    diffview-nvim
    git-blame-nvim
    git-messenger-vim
    gitsigns-nvim
    neogit
    git-messenger-vim
    committia
  ];
  tree-sitter = with pkgs.vimPlugins; [
    nvim-treesitter.withAllGrammars
    nvim-ts-rainbow
    nvim-treesitter-context
    nvim-ts-context-commentstring
    playground
    # nvim-treesitter-textobjects
  ];
  lsp = with pkgs.vimPlugins; [
    nvim-lspconfig
    lsp_extensions-nvim
    null-ls-nvim
    lsp-inlayhints-nvim
  ];
  ui = with pkgs.vimPlugins; [
    nvim-notify
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
    extraPackages = [
    ];
    plugins = with pkgs.vimPlugins;
      [
        vim-nix
        direnv-vim
        lightspeed-nvim
        lualine-nvim
        zen-mode-nvim
        zoxide-vim
        vim-test
        aerial-nvim
        vim-nixhash
        nix-develop-nvim
        vim-projectionist
        nvim-spectre
        todo-comments-nvim
        # stickybuf # https://github.com/neovim/neovim/issues/12517
        # crates-nvim
        auto-session
        # hop-nvim
        trouble-nvim
        vimtex
        plenary-nvim
        # sqlite-lua
        {
          plugin = sqlite-lua;
          config = ''
            lua << EOF
            require("init")
            EOF
            let g:sqlite_clib_path = '${pkgs.sqlite.out}/lib/libsqlite3.so'
          '';
        }
        telescope-nvim
        telescope-manix
        telescope-project-nvim
        neogen
        glance-nvim
        glow-nvim
        # (pkgs.vimUtils.buildVimPlugin
        #   {
        #     name = "telescope-smart-history-nvim";
        #     src = inputs.telescope-smart-history;
        #     buildInputs = [pkgs.zip pkgs.vim pkgs.sqlite];
        #     nativeBuildInputs = [pkgs.sqlite];
        #     dontBuild = "true";
        #   })
        nvim-web-devicons
        better-escape-nvim
        vim-floaterm
        toggleterm-nvim
        telescope-fzf-native-nvim
        telescope-frecency-nvim
        harpoon
        nvim-surround
        comment-nvim
        nvim-lightbulb
        # snippets
        luasnip
        friendly-snippets
        # end snippets
        nvim-autopairs
      ]
      ++ git
      ++ themes
      ++ lsp
      ++ tree-sitter
      ++ completion
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

  programs.bash.shellAliases = {vimdiff = "nvim -d";};
  programs.fish.shellAliases = {vimdiff = "nvim -d";};
  programs.fish.shellAliases = {vim = "nvim";};
  programs.fish.shellAliases = {vi = "nvim";};
  programs.zsh.shellAliases = {vimdiff = "nvim -d";};
}
