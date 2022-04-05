{
  self,
  flake-utils,
  nixpkgs,
  ...
} @ inputs:
(flake-utils.lib.eachDefaultSystem (system: let
  pkgs = nixpkgs.legacyPackages.${system};
in {
   devShells = {
    shell = pkgs.mkShell {
      nativeBuildInputs = [
      ];
    };
    fmtShell = pkgs.mkShell {
      name = "fmt-shell";
      nativeBuildInputs = [
        pkgs.treefmt
        pkgs.stylua
        pkgs.alejandra
      ];
    };
  };

  #devShell = pkgs.callPackage ./shell.nix {
  #};
}
  ))
