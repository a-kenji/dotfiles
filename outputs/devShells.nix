_: {
  perSystem =
    { pkgs, ... }:
    {
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
            pkgs.actionlint
          ];
        };
      };
    };
}
