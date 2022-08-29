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
  ];
  completion = with pkgs.vimPlugins; [
    cmp-nvim-lsp
    cmp-path
    cmp-buffer
    cmp_luasnip
    nvim-cmp
  ];
  git = with pkgs.vimPlugins; [
    diffview-nvim
    git-blame-nvim
    # gitsigns-nvim
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
        vim-nix
        direnv-vim
        lightspeed-nvim
        lualine-nvim
        # hop-nvim
        vimtex
        plenary-nvim
        telescope-nvim
        #surround-nvim
        (pkgs.vimUtils.buildVimPlugin
          {
            name = "nvim-surround";
            src = inputs.nvim-surround;
            buildInputs = [pkgs.zip pkgs.vim pkgs.cargo];
            dontBuild = "true";
          })
        comment-nvim
        nvim-lightbulb
        # snippets
        luasnip
        friendly-snippets
        # end snippets
        nvim-autopairs
        # lsp
        nvim-lspconfig
        lsp_extensions-nvim
        null-ls-nvim
        # end lsp
        # begin tree-sitter
        nvim-treesitter
        nvim-ts-rainbow
        playground
        # end tree-sitter
        # nvim-treesitter-textobjects
      ]
      ++ git
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
  xdg.configFile."nvim/parser/query.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-query}/parser";
  xdg.configFile."nvim/parser/json.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-json}/json";
  xdg.configFile."nvim/parser/json5.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-json5}/json5";
  xdg.configFile."nvim/parser/bibtex.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-bibtex}/bibtex";
  xdg.configFile."nvim/parser/markdown.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-markdown}/markdown";
  xdg.configFile."nvim/parser/markdown-inline.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-markdown-inline}/markdown-inline";
  xdg.configFile."nvim/parser/yaml.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-yaml}/yaml";
  xdg.configFile."nvim/parser/make.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-make}/make";
  xdg.configFile."nvim/parser/go.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-go}/go";
  xdg.configFile."nvim/parser/fish.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-fish}/fish";
  xdg.configFile."nvim/parser/fluent.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-fluent}/fluent";
  xdg.configFile."nvim/parser/rst.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-rst}/rst";
  xdg.configFile."nvim/parser/regex.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-regex}/regex";
  xdg.configFile."nvim/parser/sql.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-sql}/sql";
  xdg.configFile."nvim/parser/toml.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-toml}/toml";
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
