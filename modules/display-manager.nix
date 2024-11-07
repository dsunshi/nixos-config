{ myUser, ... }: {
  # services.xserver.displayManager.ly.enable = true;
  # services.xserver.displayManager.ly.settings = {
  #   load = false;
  #   save = false;
  # };
  services.displayManager.defaultSession = "none+xmonad";
  services.xserver.displayManager.lightdm = {
    enable = true;
    greeters.mini = {
      enable = true;
      user = myUser.username;

      extraConfig = ''
        [greeter]
        show-password-label = true
        password-label-text = password
        invalid-password-text = try again
        show-input-cursor = false
        password-alignment = left

        [greeter-theme]
        font = "Iosevka"
        font-size = 14pt
        text-color = "#DCD7BA"
        error-color = "#C4746E"
        background-image = ""
        background-color = "#1F1F28"
        window-color = "#1F1F28"
        border-color = "#363646"
        border-width = 1px
        layout-space = 14
        password-color = "#54546D"
        password-background-color = "#2A2A37"
      '';
    };
  };
}
