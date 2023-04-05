{
  pkgs,
  configDir,
  inputs,
}: let
  helixDir = configDir + "/helix";
in {
  home.packages = [pkgs.helix];
  xdg.configFile = {
    "helix/" = {
      source = helixDir;
      recursive = true;
    };
  };
}
