{
  description = "Dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";
    flake-parts.url = "github:hercules-ci/flake-parts";

    helix-nightly.url = "github:helix-editor/helix";
    helix-nightly.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = {...} @ args: import ./outputs args;
}
