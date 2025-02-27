{ myUser, lib, config, pkgs, ... }:
let
  tray = pkgs.fetchFromGitHub {
    owner = "sofian";
    repo = "openscad-tray";
    rev = "9fc472032fad5d5fd3f25ea0e230b44fe95c9ccf"; # Jan 14, 2023
    hash = "sha256-Snxl9MPfc3rVGFNVyuHEHjt5bDXGxFip6uCPctXWI2E=";
  };
  bosl = pkgs.fetchFromGitHub {
    owner = "revarbat";
    repo = "BOSL";
    rev = "4ce427a8a38786e5f74b728c1e33d9fe7d4904d2"; # Feb 19, 2023
    hash = "sha256-24vqGt0TPe09K1WTP8fDX2Wx4MlsDnigzx7Ha0mXCOg=";
  };
  bosl2 = pkgs.fetchFromGitHub {
    owner = "BelfrySCAD";
    repo = "BOSL2";
    rev = "fb8be5baa68201d2179dd30f6d16b636c232aaaf"; # Feb 27, 2025
    hash = "sha256-wwtWVr00Pl//QY5yoNGnJMF+j7tvbRjcZ+s5WRH9DmU=";
    # hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };
  catchnhole = pkgs.fetchFromGitHub {
    owner = "mmalecki";
    repo = "catchnhole";
    rev = "99428972ca2588f5ce33c0df54d097a14acf7f10"; # Version 3.0.2
    hash = "sha256-4G9zmlBZy4XfeYrHkHG4LK1aWsmVu4ZOTVzTafkCoNM=";
  };
  libPath = ".local/share/OpenSCAD/libraries";
in {
  config = lib.mkIf (!config.wsl.enable) {
    home-manager.users.${myUser.username} = {
      home = {
        packages = with pkgs; [ openscad-unstable ];
        file."${libPath}/tray".source = tray;
        file."${libPath}/BOSL".source = bosl;
        file."${libPath}/BOSL2".source = bosl2;
        file."${libPath}/catchnhole".source = catchnhole;
      };
    };
  };
}
