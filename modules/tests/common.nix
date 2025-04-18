{ pkgs, self }:
let
  home = "/home/${user}";
  user = "alice";
in
pkgs.nixosTest {
  name = "common-configuration";
  nodes.machine =
    { ... }:
    {
      imports = [
        self.inputs.home-manager.nixosModules.home-manager
        {
          home-manager.users = {
            ${user} = {
              imports = [
                self.outputs.nixosModules.home.nvim
                self.outputs.nixosModules.home.tools
                self.outputs.nixosModules.home.shell.nu
                self.outputs.nixosModules.home.shell.fish
                self.outputs.nixosModules.home.editor.helix
              ];
              programs.home-manager.enable = true;
              home.username = user;
              home.stateVersion = "23.11";
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
    start_all()
  '';
}
