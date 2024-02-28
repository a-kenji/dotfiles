_: {
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    settings = {
      format = "$all";
      add_newline = false;
      scan_timeout = 1;
      battery = {
        display = [{
          threshold = 33;
          style = "red bold";
        }];
      };
      package.disabled = true;
      rust.disabled = true;
      nix_shell = {
        symbol = "❄️";
        impure_msg = "";
      };
    };
  };
}
