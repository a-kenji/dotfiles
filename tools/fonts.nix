_: {
  perSystem = { pkgs, ... }:
    let
      fira-code = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
        <fontconfig>
          <!-- Replace the path with the actual path to your Fira Code font files -->
          <dir>${pkgs.fira-code}</dir>

          <!-- Match Fira Code font family -->
          <match target="pattern">
            <test qual="any" name="family">
              <string>Fira Code</string>
            </test>
            <edit name="hintstyle" mode="assign">
              <const>hintfull</const>
            </edit>
            <edit name="hinting" mode="assign">
              <bool>true</bool>
            </edit>
            <edit name="antialias" mode="assign">
              <bool>true</bool>
            </edit>
            <edit name="autohint" mode="assign">
              <bool>false</bool>
            </edit>
            <edit name="rgba" mode="assign">
              <const>rgb</const>
            </edit>
          </match>
        </fontconfig>
      '';
    in {
      packages.fonts = pkgs.writeScriptBin "set-fonts" ''
        export FONTCONFIG_FILE=${
          pkgs.writeTextDir "10-fira-code.conf" fira-code
        }
      '';
    };
}
