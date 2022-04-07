{
  pkgs,
  self,
}: let
  system = "x86_64-linux";
in
  pkgs.nixosTest {
    nodes.machine = {
      #config,
      pkgs,
      ...
    }: {
      #imports = [ ../common ];
      virtualisation.graphics = false;
    };

    testScript = ''
      start_all()
    '';
  }
