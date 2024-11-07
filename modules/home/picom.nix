{ myUser, pkgs, ... }: {
  home-manager.users.${myUser.username} = {
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
    home = { packages = with pkgs; [ picom ]; };
  };
}
