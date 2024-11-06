{ config, inputs, lib, pkgs, ... }: {
  home-manager.users.david.home = {
    file.".config/wallpaper.png".source = ./wallpaper.png;
  };
}
