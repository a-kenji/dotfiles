{inputs}: let
  pkgs = import inputs.nixpkgs {
    system = "x86_64-linux";
    overlays = [];
  };
  inherit (inputs) self;
  configDir = self + "/home";
in {
  home = import ./home {inherit pkgs configDir inputs;};

  home-manager = import ./home-manager inputs;

  tests = import ./tests {inherit pkgs self;};
}
