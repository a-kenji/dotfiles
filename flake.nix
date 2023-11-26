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
    helix-nightly.inputs.flake-utils.follows = "flake-utils";

    nixd.url = "github:nix-community/nixd";
    nixd.inputs.nixpkgs.follows = "nixpkgs";
    nixd.inputs.flake-parts.follows = "flake-parts";
  };
  outputs = {...} @ args: import ./outputs args;
}
