{ config, inputs, lib, pkgs, ... }: {
  home-manager.users.david = {
    home = {
      packages = with pkgs; [ xmobar feh picom-pijulius rofi-wayland ];
      file.".xmonad/xmonad.hs".source = ./xmonad/xmonad.hs;
      file.".xmobarrc".source = ./xmonad/xmobarrc;
    };
  };
}
