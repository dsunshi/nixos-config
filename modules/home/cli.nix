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
        rdfind
        aria2
        bottom
        haskellPackages.hoogle
        # (haskellPackages.hoogle.overrideAttrs ({ fixupPhase ? "", ... }: {
        #   fixupPhase = fixupPhase + ''
        #     ${haskellPackages.hoogle}/bin/hoogle generate
        #   '';
        # }))
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
        # (tealdeer.overrideAttrs ({ fixupPhase ? "", ... }: {
        #   fixupPhase = fixupPhase + ''
        #     ${tealdeer}/bin/tldr --update
        #   '';
        # }))
        tokei
      ];
    };
  };
}
