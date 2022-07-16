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
        self.outputs.nixosModules.home.nvim
        {
          home = {
            inherit stateVersion homeDirectory username;
          };
        }
      ];
  });
in {
  common = hmConfiguration {};
  tools = hmConfiguration {modules = [self.outputs.nixosModules.home.tools];};
}
