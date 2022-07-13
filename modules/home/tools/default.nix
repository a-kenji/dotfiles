{
  pkgs,
  configDir,
  ...
}: let
  gitPkgs = with pkgs; [
    git
    gitAndTools.gh # github cli
    hub
    gitui
    tig
    lazygit
    git-absorb
    difftastic
    delta
  ];
in {
  home.packages = gitPkgs;
}
