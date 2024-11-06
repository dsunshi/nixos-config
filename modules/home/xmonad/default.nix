{ config, inputs, lib, pkgs, ... }: {
  home-manager.users.david = {
    home = {
      packages = with pkgs;
        [
          xorg.xmessage # TODO: What is a better way to display help?
        ];
      file.".xmonad/xmonad.hs".source = ./xmonad.hs;
    };
  };
}
