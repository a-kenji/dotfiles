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
  base = with pkgs; [
    coreutils
    diffutils
    binutils
  ];
  extended = with pkgs; [
    alacritty
    ark
    bat
    fd
    foot
    fzf
    glow
    helix
    hexyl
    htop
    jq
    just
    lsd
    mob
    ncdu
    pdd
    ripgrep
    scc
    skim
    socat
    strace
    tmux
    tokei
    vivid
  ];
in {
  home.packages = gitPkgs ++ base ++ extended;
}
