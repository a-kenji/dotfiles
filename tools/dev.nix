_: {
  perSystem = {
    system,
    pkgs,
    lib,
    self',
    ...
  }: {
    packages.dev = pkgs.writeScriptBin "dev" ''
      exec ${lib.getExe self'.packages.tmux}
    '';
  };
}
