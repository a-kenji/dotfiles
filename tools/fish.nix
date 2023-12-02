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
    fish_variables = pkgs.writeText "fish_variables" ''
      # This file contains fish universal variable definitions.
      # VERSION: 3.0
      SETUVAR __fish_initialized:3400
      SETUVAR fish_color_autosuggestion:555\x1ebrblack
      SETUVAR fish_color_cancel:\x2dr
      SETUVAR fish_color_command:blue
      SETUVAR fish_color_comment:red
      SETUVAR fish_color_cwd:green
      SETUVAR fish_color_cwd_root:red
      SETUVAR fish_color_end:green
      SETUVAR fish_color_error:brred
      SETUVAR fish_color_escape:brcyan
      SETUVAR fish_color_history_current:\x2d\x2dbold
      SETUVAR fish_color_host:normal
      SETUVAR fish_color_host_remote:yellow
      SETUVAR fish_color_normal:normal
      SETUVAR fish_color_operator:brcyan
      SETUVAR fish_color_param:cyan
      SETUVAR fish_color_quote:yellow
      SETUVAR fish_color_redirection:cyan\x1e\x2d\x2dbold
      SETUVAR fish_color_search_match:bryellow\x1e\x2d\x2dbackground\x3dbrblack
      SETUVAR fish_color_selection:white\x1e\x2d\x2dbold\x1e\x2d\x2dbackground\x3dbrblack
      SETUVAR fish_color_status:red
      SETUVAR fish_color_user:brgreen
      SETUVAR fish_color_valid_path:\x2d\x2dunderline
      SETUVAR fish_key_bindings:fish_default_key_bindings
      SETUVAR fish_pager_color_completion:normal
      SETUVAR fish_pager_color_description:B3A06D\x1eyellow\x1e\x2di
      SETUVAR fish_pager_color_prefix:normal\x1e\x2d\x2dbold\x1e\x2d\x2dunderline
      SETUVAR fish_pager_color_progress:brwhite\x1e\x2d\x2dbackground\x3dcyan
      SETUVAR fish_pager_color_selected_background:\x2dr
    '';
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
            # --init-command 'source ${pkgs.writeScript "fish-config" config-fish}' \
            # --no-config "$@"
    '';
  };
}
