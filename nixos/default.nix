{ inputs, ... }:
let
  inherit (inputs) nixpkgs;
  nixosSystem = nixpkgs.lib.makeOverridable nixpkgs.lib.nixosSystem;
  defaultModules = [
    # make flake inputs accessible in NixOS
    { _module.args.inputs = inputs; }
    {
      imports = [
        (
          { pkgs, ... }:
          {
            nix.nixPath = [
              "nixpkgs=${pkgs.path}"
              "home-manager=${inputs.home-manager}"
            ];
            documentation.info.enable = false;
          }
        )
      ];
    }
  ];
in
{
  flake.nixosConfigurations = {
    common-test = nixosSystem {
      system = "x86_64-linux";
      modules = defaultModules ++ [
        inputs.home-manager.nixosModules.home-manager
        {
          # don't use this configuration, this is a test
          boot.loader.grub.enable = true;
          boot.loader.grub.devices = [ "/dev/sda" ];
          fileSystems."/" = {
            device = "/dev/disk/by-uuid/f2e641f6-d919-494f-84d3-94659d03d3f6";
            fsType = "ext4";
          };
          users.users.alice = {
            home = "/home/alice";
            createHome = true;
            isNormalUser = true;
            initialPassword = "alice";
          };
          programs.sway.enable = true;
        }
      ];
    };
  };
}
