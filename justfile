alias f := fmt
alias l := lint
alias uf := update-flake-lock

fmt:
    nix develop .#fmtShell --command treefmt
    nix develop .#fmtShell --command stylua ./home

lint:
    nix develop .#fmtShell --command actionlint

update-flake-lock:
    nix flake update --commit-lock-file
