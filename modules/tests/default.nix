{
  self,
  pkgs,
  ...
}: {
  minimal = import ./minimal.nix {inherit pkgs self;};
  neovim = import ./neovim.nix {inherit pkgs self;};
}
