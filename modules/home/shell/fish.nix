{
  pkgs,
  lib,
  ...
}: let
  starship-config = (pkgs.formats.toml {}).generate "starship-config" {
    format = "$all";
    add_newline = false;
    scan_timeout = 1;
    battery = {
      display = [
        {
          threshold = 33;
          style = "red bold";
        }
      ];
    };
    package.disabled = true;
    rust.disabled = true;
    nix_shell = {
      symbol = "❄️";
      impure_msg = "";
    };
  };
in {
  programs = {
    fish = {
      enable = true;
      functions = {
        nix-index-update = {
          body = ''
            set filename "index-x86_64-$(uname | tr A-Z a-z)"
            mkdir -p ~/.cache/nix-index
            pushd ~/.cache/nix-index
            # -N will only download a new version if there is an update.
            wget -q -N https://github.com/Mic92/nix-index-database/releases/latest/download/$filename
            ln -f $filename files
            popd
          '';
        };
        n = {
          body = "\n          nix run nixpkgs#$argv[1] -- $argv[2..]\n          ";
        };
        frg = {
          body = "\n          rg --ignore-case --color=always --line-number --no-heading \"$argv\" |\n              fzf --ansi \n                --color 'hl:-1:underline,hl+:-1:underline:reverse' \n                --delimiter ':' \n                --preview \"bat --color=always {1} --theme='Solarized (light)' --highlight-line {2}\" \n                --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \n                --bind \"enter:become($EDITOR +{2} {1})\"\n          ";
        };
      };
      plugins = [
        {
          name = "forgit";
          inherit (pkgs.fishPlugins.forgit) src;
        }
        {
          name = "autopair";
          inherit (pkgs.fishPlugins.autopair) src;
        }
      ];
      shellInit = ''
        set fish_greeting
        set qmark_noglob
        fish_vi_key_bindings
        bind -M insert \cp broot
        bind -M insert \co yazi
        bind \cp broot
        bind \co yazi

        source ${
          pkgs.runCommand "zoxide-fish" {} "${lib.getExe pkgs.zoxide} init fish > $out"
        }
      '';
      interactiveShellInit = ''
        if test "TERM" != dumb
          export STARSHIP_NUM_THREADS=8
          export STARSHIP_CONFIG=${starship-config}
          source ${
          pkgs.runCommand "starship-init-fish" {} ''
            ${lib.getExe pkgs.starship} init fish > $out
          ''
        };
        end

        export ATUIN_CONFIG_DIR=${
          pkgs.writeTextDir "/config.toml" ''
            update_check = false
            show_preview = true
            style = "compact"
          ''
        };
        source ${
          pkgs.runCommand "atuin-fish" {} "${lib.getExe pkgs.atuin} init fish > $out"
        }
        source ${
          pkgs.runCommand "navi-fish" {} "${lib.getExe pkgs.navi} widget fish > $out"
        }
      '';
    };
  };
}
