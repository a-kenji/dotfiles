{ pkgs, lib, ... }:
let
  starship-config = (pkgs.formats.toml { }).generate "starship-config" {
    format = "$all";
    add_newline = false;
    scan_timeout = 1;
    battery = {
      display = [{
        threshold = 33;
        style = "red bold";
      }];
    };
    package.disabled = true;
    rust.disabled = true;
    nix_shell = {
      symbol = "❄️";
      impure_msg = "";
    };
  };
in {
  programs = let flakePath = "/home/kenji/.config/nixdotfiles";
  in {
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
        n.body = "nix run nixpkgs#$argv[1] -- $argv[2..]";
        # Those are basically aliases, but are sourced more efficiently as functions
        v.body = "nvim";
        vf.body = "nvim (fzf)";
        j.body = "just";
        jl.body = "just -l";
        ls.body = "lsd";
        nd.body = "nix develop";
        nr.body = "nix run";
        nds.body = "nix develop --command $SHELL";
        dat.body = "bat --decorations=always $argv";
        tmux.body = "direnv exec / tmux";
        tm.body = "tmux";
        tml.body = "tmux list-sessions";
        tmk.body = "tmux kill-session $argv";
        clone.body = ''
          if test (count $argv) -eq 0
          echo "clone <GIT_CLONE_URL>"
          return 1
          end

          set -l temp_dir (mktemp -d)
          if not test -d $temp_dir
              return 1
          end

          cd $temp_dir
          git clone --depth=1 $argv[1]
        '';
        zl.body = "lazygit";
        nxbb = ''
          if command -v nom > /dev/null
             sudo -i nixos-rebuild build --flake ${flakePath} --log-format internal-json --keep-going &| nom --json
          else
            sudo -i nixos-rebuild build --flake ${flakePath}
          end
        '';
        nxb = ''
          if command -v nom > /dev/null
            sudo -i nixos-rebuild boot --flake ${flakePath} --log-format internal-json --keep-going &| nom --json
          else
            sudo -i nixos-rebuild boot --flake ${flakePath}
          end
        '';
        nxs = ''
          if command -v nom > /dev/null
            sudo -i nixos-rebuild switch --flake ${flakePath} --log-format internal-json --keep-going &| nom --json
          else
            sudo -i nixos-rebuild switch --flake ${flakePath}
          end
        '';

        nxu.body = "nix flake update ${flakePath}";
        nxuc.body = "nix flake update --commit-lock-file ${flakePath}";
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
          pkgs.runCommand "zoxide-fish" { }
          "${lib.getExe pkgs.zoxide} init fish > $out"
        }
      '';
      interactiveShellInit = ''
        if test "TERM" != dumb
          export STARSHIP_NUM_THREADS=8
          export STARSHIP_CONFIG=${starship-config}
          source ${
            pkgs.runCommand "starship-init-fish" { } ''
              ${lib.getExe pkgs.starship} init fish > $out
            ''
          };
        end

        export ATUIN_CONFIG_DIR=${
          pkgs.writeTextDir "/config.toml" ''
            update_check = false
            show_preview = true
            style = "compact"
            show_help = false
            enter_accept = false
            show_tabs = false
            auto_sync = true
            sync_frequency = "10m"
            sync_address = "http://vyr:8888"
          ''
        };
        source ${
          pkgs.runCommand "atuin-fish" { } ''
            # a hacky way to fix broken atuin
            export HOME=$(mktemp -d)
            ${lib.getExe pkgs.atuin} init fish > $out
          ''
        }
        source ${
          pkgs.runCommand "navi-fish" { }
          "${lib.getExe pkgs.navi} widget fish > $out"
        }
      '';
    };
  };
}
