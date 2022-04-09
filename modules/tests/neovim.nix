{
  pkgs,
  self,
}: let
  system = "x86_64-linux";
  home = "/home/test";
  servername = "${home}/nvim-socket";
  checkfile = "${home}/checkhealth";
  nvimBin = "${home}/.nix-profile/bin/nvim";
  user = "test";
in
  pkgs.nixosTest {
    nodes.machine = {
      config,
      pkgs,
      lib,
      ...
    }: {
      imports = [
        self.inputs.home-manager.nixosModules.home-manager
        {
          home-manager.users = {
            test = {
              imports = [
                self.outputs.nixosModules.home.nvim
              ];
              programs.home-manager.enable = true;
              home.homeDirectory = home;
              home.username = "test";
              xdg.configHome = home + "/.config";
            };
          };
        }
      ];

      users.users.test = {
        createHome = true;
        group = "users";
        uid = 1000;
        #isSystemUser = true;
        isNormalUser = true;
        inherit home;
      };
      virtualisation.graphics = false;
      documentation.enable = false;
    };

    testScript = ''
      from shlex import quote
      def su(user, cmd):
          return f"su - {user} -c {quote(cmd)}"

      start_all()
      machine.wait_for_file("${nvimBin}")
      machine.succeed(
      su('${user}', '${nvimBin} --version')
      )
      machine.execute(
      su('${user}', '${nvimBin} --listen ${servername} --headless >&2 &')
      )
      machine.succeed(
      su('${user}', '${nvimBin} --server ${servername} --remote-send "<cmd>checkhealth<CR>"')
      )
      machine.succeed(
      su('${user}', '${nvimBin} --server ${servername} --remote-send "<cmd>w ${checkfile}<CR>"')
      )
      machine.wait_for_file("${checkfile}")
      machine.succeed(
      su('${user}', 'cat ${checkfile}')
      )
      #machine.succeed("cat ${home}/.config/nvim/init.lua")
    '';
  }
