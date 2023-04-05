{
  pkgs,
  configDir,
  inputs,
}: {
  helix = import ./helix.nix {inherit pkgs configDir inputs;};
}
