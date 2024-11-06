{ config, inputs, lib, pkgs, ... }: {
  home-manager.users.david.home = {
    packages = with pkgs;
      [
        feh # sets the wallpaper
      ];
    file.".config/wallpaper.png".source = ./wallpaper.png;
  };
}
