{ config, inputs, lib, pkgs, ... }: {
  home-manager.users.david.home = {
    packages = with pkgs; [
      xmobar
      lm_sensors # xmobar temperature
      pamixer # volume control and display
      brightnessctl # screen brightness and keyboard LED
    ];
    file.".config/xmonad/xmobar/xmobarrc".source = ./xmobarrc;
    file.".config/xmonad/xmobar/wifi.sh".source = ./wifi.sh;
    file.".config/xmonad/xmobar/bluetooth.sh".source = ./bluetooth.sh;
    file.".config/xmonad/xmobar/volume.sh".source = ./volume.sh;
    file.".config/xmonad/xmobar/cpu_temp.sh".source = ./cpu_temp.sh;
    file.".config/xmonad/xmobar/gpu_temp.sh".source = ./gpu_temp.sh;
  };
}
