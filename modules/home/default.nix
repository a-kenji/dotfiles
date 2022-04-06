{
  pkgs,
  configDir,
  ...
}: {
  nvim = import ./nvim {inherit pkgs configDir;};
}
