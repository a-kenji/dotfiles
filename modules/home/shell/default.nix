_: {
  nu = { imports = [ ./nu.nix ./alias.nix ./plugins ]; };
  fish = { imports = [ ./fish.nix ./alias.nix ./plugins ]; };
}
