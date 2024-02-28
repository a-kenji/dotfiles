{ self, self', lib, pkgs, ... }:
let
  hmConfiguration = { modules ? [ ], stateVersion ? "23.11", }:
    (self.inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = modules ++ [{
        _module.args.self = self;
        _module.args.inputs = self.inputs;

        home = {
          inherit stateVersion;
          username = lib.mkDefault "kenji";
          homeDirectory = lib.mkDefault "/home/kenji";
          enableNixpkgsReleaseCheck = false;
        };

        manual = {
          html.enable = false;
          manpages.enable = false;
          json.enable = false;
        };
      }];
    });
in {
  minimal = hmConfiguration { };
  neovim = hmConfiguration { modules = [ self'.legacyPackages.home.nvim ]; };
  helix =
    hmConfiguration { modules = [ self'.legacyPackages.home.editor.helix ]; };
  tools = hmConfiguration { modules = [ self'.legacyPackages.home.tools ]; };
  nushell =
    hmConfiguration { modules = [ self'.legacyPackages.home.shell.nu ]; };
  fish =
    hmConfiguration { modules = [ self'.legacyPackages.home.shell.fish ]; };
  default = hmConfiguration {
    modules = [
      self'.legacyPackages.home.nvim
      self'.legacyPackages.home.tools
      self'.legacyPackages.home.shell.fish
    ];
  };
  common = hmConfiguration {
    modules = [
      self'.legacyPackages.home.nvim
      self'.legacyPackages.home.tools
      self'.legacyPackages.home.shell.nu
      self'.legacyPackages.home.editor.helix
    ];
  };
  full = hmConfiguration {
    modules = [
      self'.legacyPackages.home.nvim
      self'.legacyPackages.home.tools
      self'.legacyPackages.home.shell.nu
      self'.legacyPackages.home.shell.fish
      self'.legacyPackages.home.editor.helix
    ];
  };
}
