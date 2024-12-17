{ pkgs, lib, ... }:
# let sddmTheme = import ./sddm-theme.nix { inherit pkgs; };
{
  services.displayManager.sddm = {
    enable = true; # Enable SDDM.
    wayland.enable = true;
    sugarCandyNix = {
      enable = true; # This set SDDM's theme to "sddm-sugar-candy-nix".
      settings = {
        # Set your configuration options here.
        # Here is a simple example:
        Background = lib.cleanSource ./home/wallpaper/wallpaper.png;
        ScreenWidth = 1920;
        ScreenHeight = 1200; # 1080;
        FormPosition = "left";
        HaveFormBackground = true;
        PartialBlur = true;
        BlurRadius = 25;
        MainColor = "#DCD7BA";
        # ...
      };
    };
  };
  environment.systemPackages = with pkgs; [
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtgraphicaleffects
  ];
  # Available 24.11
  # services.xserver.displayManager.ly.enable = true;
  # services.xserver.displayManager.ly.settings = {
  #   load = false;
  #   save = false;
  # };
  # services.displayManager.defaultSession = if mySystem.wm == "xmonad" then "none+xmonad" else mySystem.wm;
  # services.xserver.displayManager.lightdm = {
  #   enable = true;
  #   greeters.mini = {
  #     enable = true;
  #     user = myUser.username;
  #
  #     extraConfig = # toml
  #       ''
  #         [greeter]
  #         show-password-label = true
  #         password-label-text = password
  #         invalid-password-text = try again
  #         show-input-cursor = false
  #         password-alignment = left
  #
  #         [greeter-hotkeys]
  #         # The modifier key used to trigger hotkeys. Possible values are:
  #         # "alt", "control" or "meta"
  #         # meta is also known as the "Windows"/"Super" key
  #         mod-key = meta
  #         # Power management shortcuts (single-key, case-sensitive)
  #         shutdown-key = s
  #         restart-key = r
  #         hibernate-key = h
  #         suspend-key = u
  #         # Cycle through available sessions
  #         session-key = e
  #
  #         [greeter-theme]
  #         font = "Iosevka"
  #         font-size = 14pt
  #         text-color = "#DCD7BA"
  #         error-color = "#C4746E"
  #         background-image = ""
  #         background-color = "#1F1F28"
  #         window-color = "#1F1F28"
  #         border-color = "#363646"
  #         border-width = 1px
  #         layout-space = 14
  #         # The character used to mask your password. Possible values are:
  #         # "-1", "0", or a single unicode character(including emojis)
  #         # A value of -1 uses the default bullet & 0 displays no characters when you
  #         # type your password.
  #         password-character = 0
  #         password-color = "#54546D"
  #         password-background-color = "#2A2A37"
  #       '';
  #   };
  # };
}
