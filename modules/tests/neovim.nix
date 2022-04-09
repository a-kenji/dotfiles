{
  pkgs,
  self,
}: let
  system = "x86_64-linux";
  servername = "/home/test/nvim-socket";
  checkfile = "/home/test/checkhealth";
  nvimBin = "/home/test/.nix-profile/bin/nvim";
in
  pkgs.nixosTest {
    nodes.machine = {
      config,
      pkgs,
      ...
    }: {
      imports = [
        self.inputs.home-manager.nixosModules.home-manager
        {
          home-manager.users = {
            test = {
              imports = [
                self.nixosModules.home.nvim
              ];
            };
          };
        }
      ];

      users.users.test = {
        createHome = true;
        group = "users";
        uid = 1000;
        isSystemUser = true;
        home = "/home/test";
      };
      virtualisation.graphics = false;
      documentation.enable = false;
    };

    testScript = ''
      start_all()
      machine.wait_for_file("${nvimBin}")
      machine.succeed(
      '${nvimBin} --version'
      )
      machine.execute(
      '${nvimBin} --listen ${servername} --headless >&2 &'
      )
      machine.succeed(
      '${nvimBin} --server ${servername} --remote-send "<cmd>checkhealth<CR>"'
      )
      machine.succeed(
      '${nvimBin} --server ${servername} --remote-send "<cmd>w ${checkfile}<CR>"'
      )
      machine.wait_for_file("${checkfile}")
      machine.succeed("cat ${checkfile}")
    '';
  }
