{ myUser, lib, config, pkgs, ... }: {
  config = lib.mkIf config.services.xserver.windowManager.xmonad.enable {
    home-manager.users.${myUser.username} = {
      # This is not permited when using picom-pijulius
      # services.picom.enable = true;
      # services.picom.settings = {
      #   backend =
      #     "glx"; # To have bluring and not destroy performance, use the GPU
      #   shadow = true;
      #   vSync = true;
      #   extraArgs = [ "--experimental-backends" ];
      #   settings = {
      #     animations = true;
      #     animation-window-mass = 1;
      #     animation-dampening = 20;
      #     animation-stiffness = 250;
      #     animation-clamping = false;
      #     animation-for-open-window = "zoom";
      #     animation-for-unmap-window = "zoom";
      #     animation-for-transient-window = "slide-down";
      #     fade-in-step = 2.8e-2;
      #     fade-out-step = 2.8e-2;
      #     fading = true;
      #   };
      #   blur = {
      #     method = "gaussian";
      #     size = 10;
      #     deviation = 2.0;
      #   };
      # };
      home = {
        packages = with pkgs; [ picom-pijulius ];
        file.".config/picom/picom.conf".source = ./pijulius.conf;
      };
    };
  };
}
