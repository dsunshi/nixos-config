{ myUser, pkgs, ... }: {
  home-manager.users.${myUser.username} = {
    home = {
      packages = with pkgs; [
        bat
        xorg.xkill
        eza
        yt-dlp
        flameshot
        tmux
        nb
        yazi
        aria2
        bottom
        neofetch
        cbonsai
        direnv
        nix-direnv
        unzip
        unrar
        p7zip
        tealdeer
      ];
    };
  };
}
