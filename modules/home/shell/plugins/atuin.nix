_: {
  programs = {
    atuin = {
      enable = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
      flags = ["--disable-ctrl-r"];
    };
  };
}
