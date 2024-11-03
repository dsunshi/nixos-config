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
        # trayer
        xorg.xmessage
        pamixer # volume control and display
      ];
      file.".local/bin/rofi-power-menu".source = ./bin/rofi-power-menu;
      file.".xmonad/xmonad.hs".source = ./xmonad/xmonad.hs;
      file.".config/rofi/config.rasi".source = ./xmonad/rofi/config.rasi;
      file.".config/rofi/colorscheme.rasi".source =
        ./xmonad/rofi/colorscheme.rasi;
      file.".config/xmonad/xmobar/xmobarrc".source = ./xmonad/xmobarrc;
      file.".config/xmonad/xmobar/wifi.sh".source = ./xmonad/wifi.sh;
      file.".config/xmonad/xmobar/bluetooth.sh".source = ./xmonad/bluetooth.sh;
      file.".config/xmonad/xmobar/volume.sh".source = ./xmonad/volume.sh;
      file.".config/xmonad/xmobar/cpu_temp.sh".source = ./xmonad/cpu_temp.sh;
      file.".config/xmonad/xmobar/gpu_temp.sh".source = ./xmonad/gpu_temp.sh;
      file.".config/xmonad/xmobar/icons/menu.xpm".source =
        ./xmonad/icons/menu.xpm;
      file.".config/xmonad/xmobar/icons/full.xpm".source =
        ./xmonad/icons/full.xpm;
      file.".config/xmonad/xmobar/icons/full_selected.xpm".source =
        ./xmonad/icons/full_selected.xpm;
      file.".config/xmonad/xmobar/icons/grid.xpm".source =
        ./xmonad/icons/grid.xpm;
      file.".config/xmonad/xmobar/icons/grid_selected.xpm".source =
        ./xmonad/icons/grid_selected.xpm;
      file.".config/xmonad/xmobar/icons/tall.xpm".source =
        ./xmonad/icons/tall.xpm;
      file.".config/xmonad/xmobar/icons/tall_selected.xpm".source =
        ./xmonad/icons/tall_selected.xpm;
      file.".config/wallpaper.png".source = ./wallpaper.png;
    };
  };
}
