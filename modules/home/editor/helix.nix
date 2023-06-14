{
  pkgs,
  configDir,
  inputs,
}: let
  helixDir = configDir + "/helix";
in {
  home.packages = [
    (inputs.helix.overrideAttrs (o: {
      patches =
        (o.patches or [])
        ++ [
          ./helix_inlayhints_at_end.patch
        ];
    }))
  ];
  xdg.configFile = {
    "helix/" = {
      source = helixDir;
      recursive = true;
    };
  };
}
