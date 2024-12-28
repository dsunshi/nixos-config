{ pkgs, lib, ... }: {
  services.displayManager.sddm = {
    enable = true; # Enable SDDM.
    wayland.enable = true;
    sugarCandyNix = {
      enable = true;
      settings = {
        Background = lib.cleanSource ./home/wallpaper/wallpaper.png;
        ScreenWidth = 1920;
        ScreenHeight = 1200; # 1080;
        FormPosition = "left";
        HaveFormBackground = true;
        PartialBlur = true;
        BlurRadius = 25;
        MainColor = "#DCD7BA";
        AccentColor = "#5E5086";
        BackgroundColor = "#1F1F28";
        Font = "Iosevka NF";
      };
    };
  };
  environment.systemPackages = with pkgs; [
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtgraphicaleffects
  ];
}
