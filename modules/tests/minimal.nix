{ pkgs }:
pkgs.nixosTest {
  name = "minimal";
  nodes.machine = _: {
    virtualisation.graphics = false;
    boot.kernelModules = [ "kvm-intel" ];
  };

  testScript = ''
    start_all()
  '';
}
