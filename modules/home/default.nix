{
  pkgs,
  config,
  ...
}: {
  nvim = import ./nvim {inherit pkgs;};
}
