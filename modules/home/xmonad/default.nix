{ myUser, pkgs, ... }: {
  home-manager.users.${myUser.username} = {
    home = {
      packages = with pkgs;
        [
          xorg.xmessage # TODO: What is a better way to display help?
        ];
      file.".xmonad/xmonad.hs".source = ./xmonad.hs;
      file.".xmonad/lib/Prompt/Eval.hs".source = ./Prompt/Eval.hs;
    };
  };
}
