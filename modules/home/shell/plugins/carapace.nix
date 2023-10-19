{lib, ...}: {
  programs = {
    carapace = {
      enable = lib.mkDefault false;
      enableFishIntegration = true;
      enableNushellIntegration = true;
    };
  };
}
