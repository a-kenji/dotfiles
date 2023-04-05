{
  pkgs,
  configDir,
  inputs,
  ...
}: {
  nvim = import ./nvim {inherit pkgs configDir inputs;};
  editor = import ./editor {inherit pkgs configDir inputs;};
  shell = import ./shell {inherit pkgs configDir inputs;};
  tools = import ./tools {inherit pkgs configDir;};
}
