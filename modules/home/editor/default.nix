{
  pkgs,
  configDir,
}: {
  helix = import ./helix.nix {inherit pkgs configDir;};
}
