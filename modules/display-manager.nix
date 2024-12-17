{ pkgs, lib, ... }: {
  services.displayManager.sddm = {
    enable = true; # Enable SDDM.
    wayland.enable = true;
    sugarCandyNix = {
      enable = true; # This set SDDM's theme to "sddm-sugar-candy-nix".
      settings = {
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
}
