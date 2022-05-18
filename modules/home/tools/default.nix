{
  pkgs,
  configDir,
  ...
}: let
  git = [
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
  home.packages = git;
}
