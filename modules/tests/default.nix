{
  self,
  pkgs,
  ...
}: {
  minimal = import ./minimal.nix {inherit pkgs self;};
}
