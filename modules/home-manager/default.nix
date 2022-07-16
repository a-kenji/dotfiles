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
  tools = hmConfiguration {modules = [self.outputs.nixosModules.home.tools];};
  common = hmConfiguration {
    modules = [
      self.outputs.nixosModules.home.nvim
      self.outputs.nixosModules.home.tools
    ];
  };
}
