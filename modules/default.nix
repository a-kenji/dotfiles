{inputs}: let
  pkgs = import inputs.nixpkgs {
    system = "x86_64-linux";
    overlays = [(import inputs.neovim-nightly-overlay)];
  };
  self = inputs.self;
  configDir = self + "/home";
in {
  home = import ./home {inherit pkgs configDir;};

  home-manager = import ./home-manager inputs;

  tests = import ./tests inputs;
}
