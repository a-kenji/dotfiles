{
  pkgs,
  configDir,
  ...
}: {
  nvim = import ./nvim {inherit pkgs configDir;};
  tools = import ./tools {inherit pkgs configDir;};
}
