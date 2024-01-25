{flake-parts, ...} @ inputs:
flake-parts.lib.mkFlake {inherit inputs;} {
  systems = [
    "x86_64-linux"
    "aarch64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];
  imports = [
    ./devShells.nix
    ./formatter.nix
    ../modules
    ../nixos
    ../tools/tmux.nix
    ../tools/alacritty.nix
    ../tools/fish.nix
    ../tools/dev.nix
    ../tools/fonts.nix
    ../tools/nvim.nix
  ];
}
