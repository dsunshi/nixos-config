{ config, inputs, lib, pkgs, ... }: {
  home-manager.users.david = {
    services.picom.enable = true;
    services.picom.settings = {
      backend = "glx"; # To have bluring not destroy performance, use the GPU
      shadow = true;
      blur = {
        method = "gaussian";
        size = 10;
        deviation = 2.0;
      };
    };
    home = {
      packages = with pkgs; [
        xmobar
        feh # sets the wallpaper
        rofi-wayland
        picom # allow window transparency
        lm_sensors # xmobar temperature
        xorg.xmessage # TODO: What is a better way to display help?
        pamixer # volume control and display
        brightnessctl # screen brightness and keyboard LED
      ];
      file.".xmonad/xmonad.hs".source = ./xmonad.hs;
    };
  };
}
