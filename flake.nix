{
  description = "Dotfiles";

  inputs = {
    copilot-chat-nvim.url = "github:CopilotC-Nvim/CopilotChat.nvim?branch=canary";
    copilot-chat-nvim.flake = false;
    copilot-lualine.url = "github:AndreM222/copilot-lualine";
    copilot-lualine.flake = false;
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";
    flake-parts.url = "github:hercules-ci/flake-parts";

    treefmt-nix.url = "github:numtide/treefmt-nix/";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = args: import ./outputs args;
}
