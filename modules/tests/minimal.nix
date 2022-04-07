{
  pkgs,
  self,
}: let
  system = "x86_64-linux";
in
  pkgs.nixosTest {
    nodes.machine = {
      config,
      pkgs,
      ...
    }: {
      #imports = [ ../common ];
      virtualisation.graphics = false;
      boot.kernelModules = [ "kvm-intel" ];
    };

    testScript = ''
      start_all()
    '';
  }
