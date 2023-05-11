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
    nvim-treesitter-textobjects
    playground
  ];
  lsp = with pkgs.vimPlugins; [
    nvim-lspconfig
    lspkind-nvim
    lsp_extensions-nvim
    null-ls-nvim
    lsp-inlayhints-nvim
    lsp_extensions-nvim
    lspkind-nvim
    null-ls-nvim
    nvim-lspconfig
  ];
  ui = with pkgs.vimPlugins; [
    nvim-notify
  ];
  nix = with pkgs.vimPlugins; [
    vim-nix
    vim-nixhash
    nix-develop-nvim
    direnv-vim
  ];
  snippets = with pkgs.vimPlugins; [
    luasnip
    friendly-snippets
  ];
  nix = with pkgs.vimPlugins; [
    vim-nix
    vim-nixhash
    nix-develop-nvim
    direnv-vim
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
        lightspeed-nvim
        lualine-nvim
        zen-mode-nvim
        zoxide-vim
        vim-test
        aerial-nvim
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
        nvim-autopairs
        ron-vim
      ]
      ++ git
      ++ themes
      ++ lsp
      ++ tree-sitter
      ++ completion
      ++ snippets
      ++ nix
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
