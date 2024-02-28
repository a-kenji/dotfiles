_: {
  perSystem = { pkgs, lib, ... }:
    let
      config-fish = ''
        # source once
        set -q __fish__tools_sourced; and exit
        set -g __fish__tools_sourced 1

        set fish_greeting
        set fish_vi_key_bindings

        export XDG_CONFIG_HOME=$XDG_CONFIG_HOME_SAVE

        if test "TERM" != dumb
          export STARSHIP_NUM_THREADS=8
          export STARSHIP_CONFIG=${starship-config}
          source ${starship-init-fish}
        end

        export ATUIN_CONFIG_DIR=${
          pkgs.writeTextDir "/config.toml" ''
            update_check = false
            show_preview = true
            style = "compact"
          ''
        };

        source ${atuin-init-fish}
        source ${direnv-init-fish}

        # https://fishshell.com/docs/current/language.html#envvar-fish_function_path
        # https://fishshell.com/docs/current/language.html#envvar-fish_history
      '';

      atuin-init-fish = pkgs.runCommand "atuin-fish" { } ''
        ${lib.getExe pkgs.atuin} init fish > $out
      '';
      direnv-init-fish = pkgs.runCommand "direnv-fish" { } ''
        ${lib.getExe pkgs.direnv} hook fish > $out
      '';
      starship-init-fish = pkgs.runCommand "starship-init-fish" { } ''
        ${lib.getExe pkgs.starship} init fish > $out
      '';
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
      config = pkgs.symlinkJoin {
        name = "fish-home";
        paths = [
          (pkgs.writeTextDir "fish/config.fish" config-fish)
          # (pkgs.writeTextDir "fish/fish_variables" fish_variables)
          (pkgs.writeTextDir "fish/conf.d/.empty" "")
          (pkgs.writeTextDir "fish/functions/.empty" "")
          (pkgs.writeTextDir "fish/completions/.empty" "")
        ];
      };
    in {
      packages.fish = pkgs.writeScriptBin "fish" ''
        set -x
        export XDG_CONFIG_HOME_SAVE=$XDG_CONFIG_HOME
        export XDG_CONFIG_HOME=${config}
        exec ${lib.getExe pkgs.fish}
        # \
              # --init-command 'source ${
                pkgs.writeScript "fish-config" config-fish
              }' \
              # --no-config "$@"
      '';
    };
}
