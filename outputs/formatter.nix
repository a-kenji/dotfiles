_: {
  perSystem = {pkgs, ...}: let
    runtimeInputs = [
      pkgs.treefmt
      pkgs.alejandra
    ];
  in {
    formatter = pkgs.writeShellApplication {
      name = "formatter";
      text = ''
        treefmt
      '';
      inherit runtimeInputs;
    };
  };
}
