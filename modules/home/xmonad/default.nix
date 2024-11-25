{ myUser, lib, config, pkgs, ... }: {
  config = lib.mkIf config.services.xserver.windowManager.xmonad.enable {
    home-manager.users.${myUser.username} = {
      home = {
        packages = with pkgs;
          [
            yad
          ];
        file.".xmonad/xmonad.hs" = {
          source = ./xmonad.hs;
          onChange = #bash
            ''
              xmonad --recompile; xmonad --restart
            '';
        };
        file.".xmonad/lib" = {
          source = ./lib;
          recursive = true;
        };
      };
    };
  };
}
