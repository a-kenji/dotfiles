{pkgs, ...}: let
  gitPkgs = with pkgs; [
    git
    gitAndTools.gh # github cli
    gh-dash
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
  language-servers = with pkgs; [
    rust-analyzer
    rnix-lsp
    python311Packages.python-lsp-server
    sumneko-lua-language-server
    haskell-language-server
    marksman
    texlab
  ];
  linters = with pkgs; [
    proselint
    statix
    codespell
    deadnix
    editorconfig-checker
    luaPackages.luacheck
    cbfmt
    shellharden
    stylua
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
    gcc
    typst
  ];
in {
  home.packages = gitPkgs ++ base ++ extended ++ language-servers ++ linters;
}
