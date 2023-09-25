{pkgs, ...}: let
  gitPkgs = with pkgs; [
    git
    gitAndTools.gh # github cli
    glab
    gh-dash
    hub
    tea
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
    # haskell-language-server
    clang-tools
    marksman
    nil
    pylyzer
    python311Packages.python-lsp-server
    rust-analyzer
    sumneko-lua-language-server
    texlab
    typst-lsp
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
    hexyl
    htop
    jq
    just
    lsd
    # mob
    page
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
    repgrep
  ];
in {
  home.packages = gitPkgs ++ base ++ extended ++ language-servers ++ linters;
}
