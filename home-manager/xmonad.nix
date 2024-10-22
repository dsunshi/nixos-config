{ config, inputs, lib, pkgs, ... }: {
  home-manager.users.david = {
    # TODO: At lest on my first attempt, this did not work ..
    # Is this path not "absolute" enough?
    # xsession.windowManager.xmonad.config = ./xmonad/xmonad.hs;
    xsession.enable = true;
    # TODO: Since we are using the path to xmobarrc twice now, it should
    # probably be a variable. Same with wallpaper.png now too.
    xsession.initExtra = ''
      feh --bg-scale ~/.config/wallpaper.png
      xmobar ~/.xmobarrc
    '';
    services.picom.enable = true;
    services.picom.settings = {
      backend = "glx";
      shadow = true;
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
      file.".config/wallpaper.png".source = ./wallpaper.png;
      # file.".config/eww/eww.yuck".source = ./xmonad/eww/eww.yuck;
      # file.".config/eww/eww.scss".source = ./xmonad/eww/eww.scss;
    };
  };
}
