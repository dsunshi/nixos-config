{ myUser, lib, config, pkgs, ... }: {
  config = lib.mkIf config.services.xserver.windowManager.xmonad.enable {
    home-manager.users.${myUser.username} = {
      home = {
        packages = with pkgs;
          [
            yad
          ];
        # TODO: home.file.<name>.onChange
        # TODO: recursive copy? Move source on right hand side to lib folder
        file.".xmonad/xmonad.hs".source = ./xmonad.hs;
        file.".xmonad/lib/Keys.hs".source = ./Keys.hs;
        file.".xmonad/lib/Config.hs".source = ./Config.hs;
        file.".xmonad/lib/Bar.hs".source = ./Bar.hs;
        file.".xmonad/lib/Prompt/Eval.hs".source = ./Prompt/Eval.hs;
      };
    };
  };
}
