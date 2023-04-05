{
  pkgs,
  self,
}: let
  home = "/home/${user}";
  servername = "${home}/nvim-socket";
  checkfile = "${home}/checkhealth";
  nvimBin = "${home}/.nix-profile/bin/nvim";
  user = "alice";
in
  pkgs.nixosTest {
    name = "neovim-configuration";
    nodes.machine = {...}: {
      imports = [
        self.inputs.home-manager.nixosModules.home-manager
        {
          home-manager.users = {
            ${user} = {
              imports = [
                self.outputs.nixosModules.home.nvim
              ];
              programs.home-manager.enable = true;
              home.username = user;
              home.stateVersion = "22.05";
            };
          };
        }
      ];

      users.users.${user} = {
        createHome = true;
        uid = 1000;
        isNormalUser = true;
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
      machine.execute("cat ${home}/.config/nvim/init.vim")
      machine.execute("cat ${home}/.config/nvim/init.lua")
      machine.execute("ls ${home}/.config/nvim/parser")
      machine.execute("ls ${home}/.config/nvim/queries")
      machine.wait_until_succeeds("cat ${home}/.config/nvim/lua/init.lua")
    '';
  }
