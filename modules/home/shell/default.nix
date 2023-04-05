{
  pkgs,
  configDir,
  inputs,
}: {
  nu = {
    programs.nushell.enable = true;
    programs.nushell.extraConfig = ''
      let-env config = {
        show_banner: false,
      }
    '';
    programs.nushell.extraEnv = ''
      # not empty
    '';
  };
}
