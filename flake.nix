{
  description = "Dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";
    flake-parts.url = "github:hercules-ci/flake-parts";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly-overlay.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly-overlay.inputs.flake-parts.follows = "flake-parts";

    helix-nightly.url = "github:helix-editor/helix";
    helix-nightly.inputs.nixpkgs.follows = "nixpkgs";
    helix-nightly.inputs.parts.follows = "flake-parts";

    crane.url = "github:ipetkov/crane";
    onagre.url = "github:oknozor/onagre";
    onagre.flake = false;
  };
  outputs = {...} @ args: import ./outputs args;
}
