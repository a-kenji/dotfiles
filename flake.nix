{
  description = "Dotfiles";

  inputs = {
    copilot-lualine.url = "github:AndreM222/copilot-lualine";
    copilot-lualine.flake = false;
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";
    flake-parts.url = "github:hercules-ci/flake-parts";

    nixd.url = "github:nix-community/nixd";
    nixd.inputs.nixpkgs.follows = "nixpkgs";
    nixd.inputs.flake-parts.follows = "flake-parts";
  };
  outputs = {...} @ args: import ./outputs args;
}
