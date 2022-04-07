{
  pkgs,
  configDir,
  ...
}: let
  nvimDir = configDir + "/nvim";
  themes = with pkgs.vimPlugins; [
    edge
    sonokai
    everforest
  ];
  completion = with pkgs.vimPlugins; [
    cmp-nvim-lsp
    cmp-path
    cmp-buffer
    cmp_luasnip
    nvim-cmp
  ];
  neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withRuby = false;
    withPython3 = false;
    withNodeJs = true;
    extraPackages = [
    ];
    plugins = with pkgs.vimPlugins;
      [
        # entrypoint for the configuration
        # needs a package as a plugin
        {
          plugin = vim-nix;
          config = "require('init')";
          type = "lua";
        }
        direnv-vim
        lightspeed-nvim
        lualine-nvim
        plenary-nvim
        telescope-nvim
        surround-nvim
        comment-nvim
        nvim-lightbulb
        luasnip
        nvim-autopairs
        # git
        diffview-nvim
        git-blame-nvim
        # lsp
        nvim-lspconfig
        lsp_extensions-nvim
        # end lsp
        nvim-treesitter
        nvim-ts-rainbow
        # nvim-treesitter-textobjects
      ]
      ++ themes
      ++ completion;
  };
in {
  programs.neovim = neovim;

  xdg.configFile."nvim/parser/c.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-c}/parser";
  xdg.configFile."nvim/parser/lua.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-lua}/parser";
  xdg.configFile."nvim/parser/rust.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-rust}/parser";
  xdg.configFile."nvim/parser/python.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-python}/parser";
  xdg.configFile."nvim/parser/bash.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-bash}/parser";
  xdg.configFile."nvim/parser/latex.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-latex}/parser";
  xdg.configFile."nvim/parser/nix.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-nix}/parser";
  xdg.configFile = {
    "nvim/lua" = {
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
