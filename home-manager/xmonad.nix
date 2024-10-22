{ config, inputs, lib, pkgs, ... }: {
  home-manager.users.david = {
    # TODO: At lest on my first attempt, this did not work ..
    # Is this path not "absolute" enough?
    # xsession.windowManager.xmonad.config = ./xmonad/xmonad.hs;
    xsession.enable = true;
    xsession.initExtra = ''
      feh --bg-scale ~/Pictures/nix.png
    '';
    services.picom.enable = true;
    services.picom.settings = {
      backend = "glx";
      blur = {
        method = "gaussian";
        size = 5;
        deviation = 2.0;
      };
    };
    home = {
      packages = with pkgs; [ xmobar feh rofi-wayland picom eww ];
      # TODO: See above
      file.".xmonad/xmonad.hs".source = ./xmonad/xmonad.hs;
      file.".xmobarrc".source = ./xmonad/xmobarrc;
      file.".config/eww/eww.yuck".source = ./xmonad/eww/eww.yuck;
      file.".config/eww/eww.scss".source = ./xmonad/eww/eww.scss;
    };
  };
}
