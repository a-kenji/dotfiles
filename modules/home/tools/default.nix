{ pkgs, ... }:
let
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
    jujutsu
  ];
  base = with pkgs; [
    coreutils
    diffutils
    binutils
  ];
  language-servers = with pkgs; [
    clang-tools
    marksman
    ruff
    nil
    nixd
    gopls
    python311Packages.python-lsp-server
    rust-analyzer
    sumneko-lua-language-server
    texlab
    typos-lsp
    tinymist
  ];
  linters = with pkgs; [
    proselint
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
    ast-grep
  ];
in
{
  home.packages = gitPkgs ++ base ++ extended ++ language-servers ++ linters;
}
