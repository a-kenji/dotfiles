{
  self,
  nixpkgs,
  home-manager,
  ...
}: let
  hmConfiguration = {
    extraModules ? [],
    system ? "x86_64-linux",
  }: (home-manager.lib.homeManagerConfiguration {
    configuration = {...}: {
      imports =
        extraModules
        ++ [
          self.outputs.nixosModules.home.nvim
        ];
    };
    inherit system;
    homeDirectory = "/home/kenji";
    username = "kenji";
  });
in {
  common = hmConfiguration {};
  tools = hmConfiguration {extraModules = [self.outputs.nixosModules.home.tools];};
}
