{ myUser, lib, config, pkgs, ... }: {
  config = lib.mkIf config.services.xserver.windowManager.xmonad.enable {
    home-manager.users.${myUser.username}.home = {
      packages = with pkgs;
        [
          feh # sets the wallpaper
        ];
      file.".config/wallpaper.png".source = ./wallpaper.png;
    };
  };
}
