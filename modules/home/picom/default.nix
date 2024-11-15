{ myUser, lib, config, pkgs, ... }: {
  config = lib.mkIf config.services.xserver.windowManager.xmonad.enable {
    home-manager.users.${myUser.username} = {
      home = {
        packages = with pkgs; [ picom-pijulius ];
        file.".config/picom/picom.conf".source = ./pijulius.conf;
      };
    };
  };
}
