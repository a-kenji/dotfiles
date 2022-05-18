{pkgs}: let
  runtimeInputs = [
    pkgs.treefmt
    pkgs.alejandra
  ];
in
  pkgs.writeShellApplication {
    name = "formatter";
    text = ''
      treefmt
    '';
    inherit runtimeInputs;
  }
