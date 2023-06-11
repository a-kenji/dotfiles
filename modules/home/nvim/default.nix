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
    cmp-path
    cmp-rg
    cmp_luasnip
    nvim-cmp
  ];
  git = with pkgs.vimPlugins; [
    committia
    diffview-nvim
    git-blame-nvim
    git-messenger-vim
    git-messenger-vim
    gitsigns-nvim
    neogit
  ];
  tree-sitter = with pkgs.vimPlugins; [
    nvim-treesitter-context
    nvim-treesitter-textobjects
    nvim-treesitter.withAllGrammars
    nvim-ts-context-commentstring
    nvim-ts-rainbow
    playground
  ];
  telescope = with pkgs.vimPlugins; [
    telescope-frecency-nvim
    telescope-fzf-native-nvim
    telescope-nvim
    telescope-project-nvim
  ];
  lsp = with pkgs.vimPlugins; [
    lsp-inlayhints-nvim
    lsp_extensions-nvim
    lspkind-nvim
    null-ls-nvim
    nvim-lspconfig
  ];
  ui = with pkgs.vimPlugins; [
    nvim-lightbulb
    nvim-web-devicons
    trouble-nvim
    zen-mode-nvim
    lualine-nvim
    nvim-notify
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
  pilot = with pkgs.vimPlugins; [
    copilot-cmp
    copilot-lua
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
        aerial-nvim
        auto-session
        better-escape-nvim
        comment-nvim
        glance-nvim
        harpoon
        leap-nvim
        lightspeed-nvim
        neogen
        nvim-autopairs
        nvim-spectre
        nvim-surround
        plenary-nvim
        ron-vim
        todo-comments-nvim
        toggleterm-nvim
        vim-floaterm
        vim-projectionist
        vim-test
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
      ++ themes
      ++ tree-sitter
      ++ pilot
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
