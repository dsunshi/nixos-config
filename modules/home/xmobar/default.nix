{ myUser, lib, config, pkgs, ... }: {

  imports = [ ./icons.nix ];

  config = lib.mkIf config.services.xserver.windowManager.xmonad.enable {

    home-manager.users.${myUser.username}.home = {
      packages = with pkgs; [
        xmobar
        lm_sensors # xmobar temperature
        pamixer # volume control and display
        brightnessctl # screen brightness and keyboard LED
      ];

      file.".config/xmonad/xmobar/xmobarrc".text = # Haskell
        ''
          Config { font = "Iosevka 10"
                 , additionalFonts = ["Iosevka 14", "Iosevka 18"]
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
                 -- https://github.com/apeyroux/home.nix/blob/51b03332c35874c5a7a43805c7fe7b8355228d45/dotfiles/xmobarrc-p53#L77
                 , commands =
                   [ Run UnsafeStdinReader
                   , Run Memory ["-t","  <fc=#8EA4A2><usedratio></fc>%"] 10
                   , Run Date "%a, %b %d  <fc=#C4746E><fn=1> </fn></fc>  %I:%M %p" "date" 10
                   , Run BatteryP ["BAT0"] ["-t", "<acstatus><watts> (<left>%)"] 360
                   , Run Com "/home/${myUser.username}/.config/xmonad/xmobar/cpu_temp.sh" [] "cpu" 10
                   , Run Com "/home/${myUser.username}/.config/xmonad/xmobar/gpu_temp.sh" [] "gpu" 10
                   -- , Run Com "/home/${myUser.username}/.config/xmonad/xmobar/bluetooth.sh" [] "bluetooth" 10
                   , Run Com "xmobar-bluetooth" [] "bluetooth" 10
                   , Run Com "/home/${myUser.username}/.config/xmonad/xmobar/wifi.sh" [] "network" 10
                   -- , Run Com "/home/${myUser.username}/.config/xmonad/xmobar/volume.sh" [] "volume" 10
                   , Run Com "xmobar-volume" [] "volume" 10
                   , Run Kbd [("us(colemak_dh_ortho)", "ck"), ("us", "us")]
                   , Run Brightness ["-t", "<fn=0>󰃞 </fn><percent>%", "--", "-D", "intel_backlight"] 60
                   , Run DiskU [("/", "/: <usedp>% (<used>/<size>)")] [] 20
                   ]
                 , sepChar = "%"
                 , alignSep = "}{"
                 , template = "\
                      \  <fn=2><fc=#699AD7></fc><fc=#5E5086> </fc></fn>  \
                      \%UnsafeStdinReader%\
                      \}\
                      \%date%\
                      \{\
                      \%disku%\
                      \  \
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
  };
}
