{ myUser, lib, config, pkgs, ... }:
let
  DISABLED = "#727169";
  FG = "#DCD7BA";
  RED = "#C34043";
  volume = pkgs.writeShellScriptBin "xmobar-volume" # bash
    ''
      VOLUME=$(pamixer --get-volume)

      OFF_ICON="<fn=0></fn>"
      ON_ICON="<fn=0></fn>"
      if [ "$VOLUME" -eq 0 ]; then
          echo "<fc=${RED}>$OFF_ICON</fc>"
      else
          echo "$ON_ICON   $VOLUME%"
      fi
    '';
  bluetooth = pkgs.writeShellScriptBin "xmobar-bluetooth" # bash
    ''
      regex="([0-9A-Z]*:)+"
      DEVICES=$(bluetoothctl devices)
      ICON="󰂲"
      COLOR=${DISABLED}
      for DEVICE in $DEVICES
      do
          if [[ $DEVICE =~ $regex ]]; then
              STATUS=$(bluetoothctl info $DEVICE | grep "Connected" | awk '{print $2}')
              if [ $STATUS = "yes" ]; then
                  ICON="󰂯"
                  COLOR=${FG}
              fi
          fi
      done

      echo "<fc=$COLOR><fn=4>$ICON</fn></fc>"
    '';
in {
  config = lib.mkIf config.services.xserver.windowManager.xmonad.enable {
    home-manager.users.${myUser.username}.home = {
      packages = with pkgs; [ volume bluetooth ];
      file.".config/xmonad/xmobar/wifi.sh".source = ./wifi.sh;
      # file.".config/xmonad/xmobar/bluetooth.sh".source = ./bluetooth.sh;
      # file.".config/xmonad/xmobar/volume.sh".source = ./volume.sh;
      file.".config/xmonad/xmobar/cpu_temp.sh".source = ./cpu_temp.sh;
      file.".config/xmonad/xmobar/gpu_temp.sh".source = ./gpu_temp.sh;
    };
  };
}
