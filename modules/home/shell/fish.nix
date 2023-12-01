{pkgs, ...}: {
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
          body = "
          nix run nixpkgs#$argv[1] -- $argv[2..]
          ";
        };
        frg = {
          body = "
          rg --ignore-case --color=always --line-number --no-heading \"$argv\" |
              fzf --ansi \
                --color 'hl:-1:underline,hl+:-1:underline:reverse' \
                --delimiter ':' \
                --preview \"bat --color=always {1} --theme='Solarized (light)' --highlight-line {2}\" \
                --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
                --bind \"enter:become($EDITOR +{2} {1})\"
          ";
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
      '';
    };
  };
}
