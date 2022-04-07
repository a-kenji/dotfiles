{
  self,
  flake-utils,
  nixpkgs,
  ...
} @ inputs:
(flake-utils.lib.eachDefaultSystem (
  system: let
    pkgs = nixpkgs.legacyPackages.${system};
  in rec {
    devShells = import ./devShells.nix {inherit pkgs;};
  }
))
// {
  nixosModules = import (self + "/modules") {inherit inputs;};
}
