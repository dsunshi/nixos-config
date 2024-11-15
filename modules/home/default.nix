{ myUser, pkgs, ... }: {
  imports = [
    ./cli.nix
    ./games.nix
    ./kitty.nix
    ./nvim.nix
    ./picom
    ./qutebrowser
    ./rofi
    ./sh.nix
    ./wallpaper
    ./xmobar
    ./xmonad
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users = {
      ${myUser.username} = {
        xsession = {
          enable = true;
          initExtra = "${pkgs.autorandr}/bin/autorandr --change";
        };
        programs.git = {
          enable = true;
          userName = myUser.name;
          userEmail = myUser.email;
        };
        home = {
          sessionVariables = {
            BROWSER = "firefox";
            EDITOR = "nvim";
            # SHELL = "fish";
            TERMINAL = "kitty";
          };
          packages = with pkgs; [
            calibre
            gnumake
            mypaint
            okular
            spotify
            mypaint-brushes
            prusa-slicer
            gimp
            freetube
            blender
            gpick
            vlc
          ];
          # Custom prompt for GHCI
          file.".ghci".text = '':set prompt "λ> "'';
          # You do not need to change this if you're reading this in the future.
          # Don't ever change this after the first build.  Don't ask questions.
          stateVersion = "24.05";
        };
      };
      # You do not need to change this if you're reading this in the future.
      # Don't ever change this after the first build.  Don't ask questions.
      root = _: { home.stateVersion = "24.05"; };
    };
  };
}

