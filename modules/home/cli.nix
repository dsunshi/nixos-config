{ myUser, pkgs, pkgs-unstable, ... }: {
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
        helix
        sd
        nvd
        pkgs-unstable.yazi
        rdfind
        fclones
        aria2
        bottom
        haskellPackages.hoogle
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
