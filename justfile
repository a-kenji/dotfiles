fmt:
    nix develop .#fmtShell --command treefmt
    nix develop .#fmtShell --command stylua ./home
