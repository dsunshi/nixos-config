{ config, inputs, lib, pkgs, ... }: {
  home-manager.users.david = {
    home = {
      packages = with pkgs; [ xmobar feh ];
      file.".xmonad/xmonad.hs".source = ./xmonad/xmonad.hs;
      file.".config/xmobar/xmobar.hs".source = ./xmonad/xmobar.hs;
    };
  };
}
