{
  self,
  nixpkgs,
  home-manager,
  ...
}: let
  hmConfiguration = {
    modules ? [],
    system ? "x86_64-linux",
    stateVersion ? "21.11",
    homeDirectory ? "/home/kenji",
    username ? "kenji",
    pkgs ? nixpkgs.legacyPackages.${system},
  }: (home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    modules =
      modules
      ++ [
        {
          home = {
            inherit stateVersion homeDirectory username;
          };
        }
      ];
  });
in {
  minimal = hmConfiguration {};
  neovim = hmConfiguration {modules = [self.outputs.nixosModules.home.nvim];};
  helix = hmConfiguration {
    modules = [self.outputs.nixosModules.home.editor.helix];
  };
  tools = hmConfiguration {modules = [self.outputs.nixosModules.home.tools];};
  nushell = hmConfiguration {
    modules = [self.outputs.nixosModules.home.shell.nu];
  };
  common = hmConfiguration {
    modules = [
      self.outputs.nixosModules.home.nvim
      self.outputs.nixosModules.home.tools
      self.outputs.nixosModules.home.shell.nu
      self.outputs.nixosModules.home.editor.helix
    ];
  };
}
