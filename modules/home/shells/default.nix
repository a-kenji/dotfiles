{
  pkgs,
  config,
  ...
}: {
  packages = with pkgs; [
    fd
    exa
    bat
    tig
    hexyl
    ripgrep
    skim
    glow
    jq
    fzf

    #git
    delta
    git-absorb
    difftastic
    lazygit
    du-dust
    ncdu
    tmux

    # nix tools
    hydra-check

    (pkgs.nerdfonts.override {
      fonts = ["FiraCode"];
    })
  ];
}
