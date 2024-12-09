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
        nh
        nix-output-monitor
        fd
        nvd
        yazi
        aria2
        bottom
        neofetch
        fastfetch
        cowsay
        cbonsai
        direnv
        restic
        nix-direnv
        ouch
        unzip
        unrar
        p7zip
        tealdeer
        tokei
      ];
    };
  };
}
