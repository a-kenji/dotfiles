{ inputs, ... }: {

  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem = _: {
    treefmt = {
      projectRootFile = "flake.lock";
      programs.deadnix.enable = true;
      programs.nixfmt.enable = true;
      programs.rustfmt.enable = true;
      programs.taplo.enable = true;
      programs.yamlfmt.enable = true;
    };
  };
}
