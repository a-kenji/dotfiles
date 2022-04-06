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
    devShells = {
      default = pkgs.mkShell {
        nativeBuildInputs = [
          pkgs.git
          pkgs.just
        ];
      };
      fmtShell = pkgs.mkShell {
        name = "fmt-shell";
        nativeBuildInputs = [
          pkgs.treefmt
          pkgs.stylua
          pkgs.alejandra
          pkgs.shfmt
          pkgs.shellcheck
        ];
      };
      devShell = devShells.default;
    };
  }
))
// {
  nixosModules = import ./modules {inherit inputs;};
}
