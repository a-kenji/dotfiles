{
  pkgs,
  config,
  ...
}: {
  home = import ./home {inherit pkgs config;};
}
