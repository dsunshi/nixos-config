{ myUser, pkgs, ... }: {
  home-manager.users.${myUser.username}.home = {
    packages = with pkgs; [
      xmobar
      lm_sensors # xmobar temperature
      pamixer # volume control and display
      brightnessctl # screen brightness and keyboard LED
    ];
    file.".config/xmonad/xmobar/wifi.sh".source = ./wifi.sh;
    file.".config/xmonad/xmobar/bluetooth.sh".source = ./bluetooth.sh;
    file.".config/xmonad/xmobar/volume.sh".source = ./volume.sh;
    file.".config/xmonad/xmobar/cpu_temp.sh".source = ./cpu_temp.sh;
    file.".config/xmonad/xmobar/gpu_temp.sh".source = ./gpu_temp.sh;
    file.".config/xmonad/xmobar/xmobarrc".text = ''
      Config { font = "Iosevka Bold 10"
             , additionalFonts = ["Iosevka 14", "Iosevka 20"]
             , border = NoBorder
             , bgColor = "#1F1F28"
             , fgColor = "#DCD7BA"
             , alpha = 202
             , position = BottomSize C 100 40
             -- , textOffset = 24
             -- , textOffsets = [ 25, 24 ]
             , lowerOnStart = True
             , allDesktops = True
             , persistent = False
             , hideOnStart = False
             , iconRoot = "/home/${myUser.username}/.config/xmonad/xmobar/icons/"
             -- https://codeberg.org/xmobar/xmobar/src/branch/master/doc/plugins.org
             , commands =
               [ Run UnsafeStdinReader
               , Run Memory ["-t","  <fc=#8EA4A2><usedratio></fc>%"] 10
               , Run Date "%a, %b %d  <fc=#C4746E><fn=1> </fn></fc>  %I:%M:%S %p" "date" 10
               , Run BatteryP ["BAT0"] ["-t", "<acstatus><watts> (<left>%)"] 360
               , Run Com "/home/${myUser.username}/.config/xmonad/xmobar/cpu_temp.sh" [] "cpu" 10
               , Run Com "/home/${myUser.username}/.config/xmonad/xmobar/gpu_temp.sh" [] "gpu" 10
               , Run Com "/home/${myUser.username}/.config/xmonad/xmobar/bluetooth.sh" [] "bluetooth" 10
               , Run Com "/home/${myUser.username}/.config/xmonad/xmobar/wifi.sh" [] "network" 10
               , Run Com "/home/${myUser.username}/.config/xmonad/xmobar/volume.sh" [] "volume" 10
               , Run Kbd [("us(colemak_dh_ortho)", "ck"), ("us", "us")]
               , Run Brightness ["-t", "<fn=0>󰃞 </fn><percent>%", "--", "-D", "intel_backlight"] 60
               ]
             , sepChar = "%"
             , alignSep = "}{"
             , template = "\
                  \  <fn=2><fc=#699AD7></fc><fc=#5E5086> </fc></fn>  \
                  \%UnsafeStdinReader%\
                  \}\
                  \%date%\
                  \{\
                  \%battery%\
                  \  \
                  \%volume%\
                  \  \
                  \%bright%\
                  \  \
                  \%memory%\
                  \  \
                  \%cpu%\
                  \  \
                  \%gpu%\
                  \  \
                  \%kbd%\
                  \  \
                  \%bluetooth%\
                  \  \
                  \%network%    \
                  \"
             }
    '';
  };
}