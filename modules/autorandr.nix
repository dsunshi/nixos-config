let
  # Since the docking statation can cause xrandr to return different names we make the names configurable
  laptopName = "eDP-1";
  upliftLeftName = "DVI-I-3-2";
  upliftRightName = "DVI-I-2-1";
  # The fingerprint values do not change, they are just here to make the following section more readable
  laptopFP =
    "00ffffffffffff004d104f15000000002e1f0104a51d127807de50a3544c99260f505400000001010101010101010101010101010101ed7b80a070b047403020360020b410000018ed7b80a070b03e453020360020b410000018000000fd003078999920010a202020202020000000fc004c513133344e314a5735340a2000a9";
  upliftRightFP =
    "00ffffffffffff0009d1e67845540000131f0103803c22782e4825a756529c270f5054a56b80d1c0b300a9c08180810081c001010101023a801871382d40582c450056502100001e000000ff0043354d30313037343031510a20000000fd00324c1e5311000a202020202020000000fc0042656e51204757323738300a20012e020322f14f901f04130312021101140607151605230907078301000065030c001000023a801871382d40582c450056502100001f011d8018711c1620582c250056502100009f011d007251d01e206e28550056502100001e8c0ad08a20e02d10103e960056502100001800000000000000000000000000000000000000000047";
  upliftLeftFP =
    "00ffffffffffff0009d1e67845540000131f0103803c22782e4825a756529c270f5054a56b80d1c0b300a9c08180810081c001010101023a801871382d40582c450056502100001e000000ff0043354d30303137353031510a20000000fd00324c1e5311000a202020202020000000fc0042656e51204757323738300a20012d020322f14f901f04130312021101140607151605230907078301000065030c001000023a801871382d40582c450056502100001f011d8018711c1620582c250056502100009f011d007251d01e206e28550056502100001e8c0ad08a20e02d10103e960056502100001800000000000000000000000000000000000000000047";
in { pkgs, ... }: {

  environment.systemPackages = with pkgs; [ autorandr ];

  services.autorandr = {
    enable = true;
    profiles = {
      "laptop" = {
        fingerprint = { ${laptopName} = laptopFP; };
        config = {
          ${laptopName} = {
            enable = true;
            primary = true;
            position = "0x0";
            mode = "1920x1200";
          };
        };
      };

      "uplift" = {
        fingerprint = {
          ${laptopName} = laptopFP;
          ${upliftLeftName} = upliftLeftFP;
          ${upliftRightName} = upliftRightFP;
        };
        config = {
          ${laptopName} = {
            enable = true;
            primary = false;
            position = "3840x1080";
            mode = "1920x1200";
          };

          ${upliftLeftName} = {
            enable = true;
            primary = false;
            position = "0x0";
            mode = "1920x1080";
          };

          ${upliftRightName} = {
            enable = true;
            primary = true;
            position = "1920x0";
            mode = "1920x1080";
          };
        };
      };

      "reverse" = {
        fingerprint = {
          ${laptopName} = laptopFP;
          ${upliftLeftName} = upliftLeftFP;
          ${upliftRightName} = upliftRightFP;
        };
        config = {
          ${laptopName} = {
            enable = true;
            primary = false;
            position = "3840x1080";
            mode = "1920x1200";
          };

          ${upliftLeftName} = {
            enable = true;
            primary = true;
            position = "1920x0";
            mode = "1920x1080";
          };

          ${upliftRightName} = {
            enable = true;
            primary = false;
            position = "0x0";
            mode = "1920x1080";
          };
        };
      };
    };
  };
}
