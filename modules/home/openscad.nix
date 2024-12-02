{ myUser, lib, config, pkgs, ... }:
let
  tray = pkgs.fetchFromGitHub {
    owner = "sofian";
    repo = "openscad-tray";
    rev = "9fc472032fad5d5fd3f25ea0e230b44fe95c9ccf";
    hash = "sha256-Snxl9MPfc3rVGFNVyuHEHjt5bDXGxFip6uCPctXWI2E=";
  };
  bosl2 = pkgs.fetchFromGitHub {
    owner = "BelfrySCAD";
    repo = "BOSL2";
    rev = "c442c5159ae605dfe5d4f0262d521aeae02ea6c3";
    hash = "sha256-ZH33mTbef2O9xkZ9pPrq/EBc4PlVuUamySEVAiA4vpI=";
  };
  catchnhole = pkgs.fetchFromGitHub {
    owner = "mmalecki";
    repo = "catchnhole";
    rev = "99428972ca2588f5ce33c0df54d097a14acf7f10";
    hash = "sha256-4G9zmlBZy4XfeYrHkHG4LK1aWsmVu4ZOTVzTafkCoNM=";
  };
  libPath = ".local/share/OpenSCAD/libraries";
in {
  config = lib.mkIf (!config.wsl.enable) {
    home-manager.users.${myUser.username} = {
      home = {
        packages = with pkgs; [ openscad-unstable ];
        file."${libPath}/tray".source = tray;
        file."${libPath}/BOSL2".source = bosl2;
        file."${libPath}/catchnhole".source = catchnhole;
      };
    };
  };
}
