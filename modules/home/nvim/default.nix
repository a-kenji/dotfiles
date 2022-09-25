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
  ];
  git = with pkgs.vimPlugins; [
    diffview-nvim
    git-blame-nvim
    # gitsigns-nvim
    neogit
  ];
  tree-sitter = with pkgs.vimPlugins; [
    nvim-treesitter
    nvim-ts-rainbow
    nvim-treesitter-context
    playground
    # nvim-treesitter-textobjects
  ];
  lsp = with pkgs.vimPlugins; [
    nvim-lspconfig
    lsp_extensions-nvim
    null-ls-nvim
    lsp-inlayhints-nvim
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
      ]
      ++ git
      ++ themes
      ++ lsp
      ++ tree-sitter
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
  xdg.configFile."nvim/parser/scheme.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-scheme}/scheme";
  xdg.configFile."nvim/parser/comment.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-comment}/comment";
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
