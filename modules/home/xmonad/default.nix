{ myUser, lib, config, pkgs, ... }: {
  config = lib.mkIf config.services.xserver.windowManager.xmonad.enable {
    home-manager.users.${myUser.username} = {
      home = {
        packages = with pkgs; [ yad ];
        file.".xmonad/xmonad.hs" = {
          source = ./xmonad.hs;
          onChange = # bash
            ''
              ${pkgs.haskellPackages.xmonad_0_18_0}/bin/xmonad --recompile; ${pkgs.haskellPackages.xmonad_0_18_0}/bin/xmonad --restart
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
