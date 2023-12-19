_: {
  perSystem = {
    pkgs,
    lib,
    ...
  }: let
    config-fish = ''
      # source once
      set -q __fish__tools_sourced; and exit
      set -g __fish__tools_sourced 1

      set fish_greeting
      set fish_vi_key_bindings

      # export XDG_CONFIG_HOME=$XDG_CONFIG_HOME_SAVE

      if test "TERM" != dumb
        export STARSHIP_NUM_THREADS=8
        export STARSHIP_CONFIG=${starship-config}
        source ${starship-init-fish}
      end

      source ${atuin-init-fish}
      source ${direnv-init-fish}
      source ${fish_variables}
      # https://fishshell.com/docs/current/language.html#envvar-fish_function_path
      # https://fishshell.com/docs/current/language.html#envvar-fish_history
    '';

    atuin-init-fish = pkgs.runCommand "atuin-fish" {} ''
      ${lib.getExe pkgs.atuin} init fish > $out
    '';
    direnv-init-fish = pkgs.runCommand "direnv-fish" {} ''
      ${lib.getExe pkgs.direnv} hook fish > $out
    '';
    starship-init-fish = pkgs.runCommand "starship-init-fish" {} ''
      ${lib.getExe pkgs.starship} init fish > $out
    '';
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
    # fish-cruft = pkgs.runCommand "fish-cruft" { } ''
    #   set -x
    #   XDG_CONFIG_HOME=
    #   ${lib.getExe pkgs.fish} --command exit
    #   cp fish/fish_variables $out
    # '';
    fish_variables = pkgs.writeText "fish_variables" ''
      # This file contains fish universal variable definitions.
      # VERSION: 3.0
      # set -u __fish_initialized:3400
      # set -u fish_color_autosuggestion:555\x1ebrblack
      # set -g fish_color_cancel:\x2dr
      # set -g fish_color_command:blue
      # set -g fish_color_comment:red
      # set -g fish_color_cwd:green
      # set -g fish_color_cwd_root:red
      # set -g fish_color_end:green
      # set -g fish_color_error:brred
      # set -g fish_color_escape:brcyan
      # set -g fish_color_history_current:\x2d\x2dbold
      # set -g fish_color_host:normal
      # set -g fish_color_host_remote:yellow
      # set -g fish_color_normal:normal
      # set -g fish_color_operator:brcyan
      # set -g fish_color_param:cyan
      # set -g fish_color_quote:yellow
      # set -g fish_color_redirection:cyan\x1e\x2d\x2dbold
      # set -g fish_color_search_match:bryellow\x1e\x2d\x2dbackground\x3dbrblack
      # set -g fish_color_selection:white\x1e\x2d\x2dbold\x1e\x2d\x2dbackground\x3dbrblack
      # set -g fish_color_status:red
      # set -g fish_color_user:brgreen
      # set -g fish_color_valid_path:\x2d\x2dunderline
      # set -g fish_key_bindings:fish_default_key_bindings
      # set -g fish_pager_color_completion:normal
      # set -g fish_pager_color_description:B3A06D\x1eyellow\x1e\x2di
      # set -g fish_pager_color_prefix:normal\x1e\x2d\x2dbold\x1e\x2d\x2dunderline
      # set -g fish_pager_color_progress:brwhite\x1e\x2d\x2dbackground\x3dcyan
      # set -g fish_pager_color_selected_background:\x2dr
    '';
  in {
    packages.fish = pkgs.writeScriptBin "fish" ''
      export XDG_CONFIG_HOME_SAVE=$XDG_CONFIG_HOME
      # export XDG_CONFIG_HOME=${pkgs.writeTextDir "fish/config.fish" config-fish}
      exec ${lib.getExe pkgs.fish} \
            --init-command 'source ${pkgs.writeScript "fish-config" config-fish}' \
            --no-config "$@"
    '';
  };
}
