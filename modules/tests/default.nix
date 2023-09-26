{
  self,
  pkgs,
  ...
}: {
  common = import ./common.nix {inherit pkgs self;};
  minimal = import ./minimal.nix {inherit pkgs self;};
  neovim = import ./neovim.nix {inherit pkgs self;};
}
