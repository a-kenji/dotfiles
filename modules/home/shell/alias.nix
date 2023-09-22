_: let
  flakePath = "/home/kenji/.config/nixdotfiles";
in {
  # only portable aliases
  home = {
    shellAliases = {
      gr = "cd $(git rev-parse --show-toplevel)";
      gs = "git status";
      j = "just";
      jl = "just -l";
      ls = "lsd";
      nb = "nix build";
      nd = "nix develop";
      npi = "nix profile install";
      npl = "nix profile list";
      npr = "nix profile remove";
      nr = "nix run";
      nxb = "sudo -i nixos-rebuild build --flake ${flakePath}";
      nxs = "sudo -i nixos-rebuild switch --flake ${flakePath}";
      nxu = "nix flake update ${flakePath}";
      nxuc = "nix flake update --commit-lock-file ${flakePath}";
      rm = "rm -v";
      tempdir = "cd $(TMPDIR=/tmp mktemp -d)";
      tmux = "direnv exec / tmux";
      v = "nvim";
      zl = "lazygit";
    };
  };
}
