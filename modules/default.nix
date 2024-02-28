{ self, inputs, ... }: {
  perSystem = { config, pkgs, lib, self', ... }:
    let configDir = self + "/home";
    in {
      legacyPackages = {
        home-manager =
          import ./home-manager { inherit self self' config pkgs lib; };
        home = import ./home { inherit pkgs configDir inputs; };
        tests = import ./tests { inherit pkgs self self'; };
      };
    };
}
