{
  pkgs,
  configDir,
  inputs,
  ...
}: {
  nvim = import ./nvim {inherit pkgs configDir inputs;};
  tools = import ./tools {inherit pkgs configDir;};
}
