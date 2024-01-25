_: {
  perSystem = {
    pkgs,
    lib,
    ...
  }: let
    vim_appname = "kenjinvim";
    deps = [
      pkgs.nil
      pkgs.nixpkgs-fmt
      pkgs.taplo-lsp
      pkgs.ripgrep
      pkgs.fd
    ];
    # nvim_config = pkgs.runCommand "nvim_config" { } "\n      echo test > $out";
    nvim_config = pkgs.writeText "nvim_config" ''
      -- # vim.opt.runtimepath = '${pkgs.neovim}/share'
      -- # vim.api.nvim_command('set runtimepath^=~/.vim')
      -- vim.api.nvim_command('set runtimepath=$HOME/.config/nvim')
      vim.api.nvim_command('set runtimepath=${pkgs.neovim-unwrapped}/share/nvim/runtime')
      vim.api.nvim_command('set runtimepath^=${plugins}')
      vim.api.nvim_command('set packpath=${plugins}')
      vim.api.nvim_command('set packpath^=${pkgs.vimPlugins.plenary-nvim}')
      vim.api.nvim_command('set runtimepath^=${pkgs.vimPlugins.plenary-nvim}')
      vim.api.nvim_command('set runtimepath^=${pkgs.vimPlugins.telescope-nvim}')
      vim.api.nvim_command('set runtimepath^=${pkgs.vimPlugins.nvim-lspconfig}')
      vim.api.nvim_command('set runtimepath^=${pkgs.vimPlugins.nvim-treesitter.withAllGrammars}')
      vim.api.nvim_command('set runtimepath^=${pkgs.vimPlugins.nvim-treesitter-context}')
      vim.api.nvim_command('set runtimepath^=${pkgs.vimPlugins.nvim-treesitter-textobjects}')
      vim.api.nvim_command('set runtimepath^=${pkgs.vimPlugins.gitsigns-nvim}')
      vim.api.nvim_command('set runtimepath^=${pkgs.vimPlugins.edge}')
      vim.api.nvim_command('set runtimepath^=${pkgs.vimPlugins.leap-nvim}')
      vim.api.nvim_command('set runtimepath^=${pkgs.vimPlugins.lualine-nvim}')
      -- vim.api.nvim_command('let &packpath=${plugins}')
      -- vim.api.nvim_command('let packpath^= ${plugins}')
      vim.o.termguicolors = true

      vim.cmd [[
      set background=dark
      let g:edge_style = 'neon'
      colorscheme edge
      ]]
      require("lualine").setup()
      vim.g.edge_enable_italic = 1
      --vim.g:edge_disable_italic_comment = 1
      vim.g.lightline_theme = "edge"



      require("lspconfig").nixd.setup({})
      require("lspconfig").rust_analyzer.setup({})
      require("lspconfig").ruff_lsp.setup({})

      require("leap").add_default_mappings()


       require('plenary')
       require('telescope').setup{}
       vim.g.leader = "<Space>"
       vim.g.mapleader = " "
       vim.g.maplocalleader = " "
       vim.o.relativenumber = true
       vim.o.number = true
       vim.wo.signcolumn = "yes"
       vim.wo.colorcolumn = "80"
       local builtin = require('telescope.builtin')
       vim.keymap.set('n', '<leader>lf', builtin.git_files, {})
       vim.keymap.set('n', '<C-P>', builtin.find_files, {})
       vim.keymap.set('n', '<leader>lg', builtin.live_grep, {})
       vim.keymap.set('n', ';', ':', {noremap = true})
    '';
    plugins = pkgs.linkFarm "plugins" {
      lspconfig = pkgs.vimPlugins.nvim-lspconfig;
      plenary = pkgs.vimPlugins.plenary-nvim;
      telescope = pkgs.vimPlugins.telescope-nvim;
    };
    nvim_dir = pkgs.linkFarm "plugins" {
      # lspconfig = pkgs.vimPlugins.nvim-lspconfig;
      # plenary = pkgs.vimPlugins.plenary-nvim;
      # telescope = pkgs.vimPlugins.telescope-nvim;
      "init.lua" = nvim_config;
    };
  in {
    packages.v = pkgs.writeScriptBin "v" ''
      set -efux
      unset VIMINIT
      export PATH=$PATH:${
        pkgs.buildEnv {
          name = "deps";
          paths = deps;
        }
      }/bin
      # export NVIM_APPNAME=${vim_appname}
      echo ${plugins}
      HOME=$(mktemp -d)
      mkdir -p $HOME/.config $HOME/.local/share/
      # ln -sfT ${plugins} "$HOME"/.config/${vim_appname}
      ln -sfT ${nvim_dir} "$HOME"/.config/nvim
      if [[ -d $HOME/.local/share/lassvim/lazy/telescope-fzf-native.nvim ]]; then
        # mkdir -p "$HOME/.local/share/${vim_appname}/lazy/telescope-fzf-native.nvim/build"
        mkdir -p "$HOME/.local/share/nvim/lazy/telescope-fzf-native.nvim/build"
        # ln -sf "${pkgs.vimPlugins.telescope-fzf-native-nvim}/build/libfzf.so" "$HOME/.local/share/${vim_appname}/lazy/telescope-fzf-native.nvim/build/libfzf.so"
        ln -sf "${pkgs.vimPlugins.telescope-fzf-native-nvim}/build/libfzf.so" "$HOME/.local/share/nvim/lazy/telescope-fzf-native.nvim/build/libfzf.so"
      fi
      nvim --headless -c 'quitall'
      # export VIMINIT="$HOME"/.config/nvim/init.lua
      export XDG_CONFIG_HOME=$HOME/.config
      exec ${pkgs.neovim}/bin/nvim "$@"
    '';
  };
}
