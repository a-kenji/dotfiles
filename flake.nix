{
  description = "Dotfiles";

  inputs = {
     flake-utils.url = "github:numtide/flake-utils";
     nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
     home-manager.url = "github:nix-community/home-manager";
     home-manager.inputs.nixpkgs.follows = "nixpkgs";

  };
  outputs = {...} @ args: import ./outputs.nix args;
}
