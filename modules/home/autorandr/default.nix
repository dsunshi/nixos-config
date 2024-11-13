{ myUser, pkgs, ... }: {
  home-manager.users.${myUser.username} = {
    home = {
      packages = with pkgs; [ autorandr ];
      file.".config/autorandr/uplift/config".source = ./uplift/config;
      file.".config/autorandr/uplift/setup".source = ./uplift/setup;
    };
    services.autorandr = { enable = true; };
  };
}
