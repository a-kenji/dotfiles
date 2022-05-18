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
    formatter = pkgs.alejandra;
  }
))
// {
  nixosModules = import (self + "/modules") {inherit inputs;};
  nixosConfigurations = import (self + "/nixos") {inherit inputs;};
}
