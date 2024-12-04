{ myUser, pkgs, ... }: {
  imports = [
    ./cli.nix
    ./games.nix
    ./kitty.nix
    ./programs.nix
    ./gtk.nix
    ./nvim.nix
    ./openscad.nix
    ./cursor.nix
    ./firefox.nix
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
    backupFileExtension = "backup";

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
          delta = { enable = true; };
          aliases = { who = "show -s --format='%ae' HEAD"; };
          extraConfig = { init.defaultBranch = "master"; };
        };
        home = {
          sessionVariables = {
            MANPAGER = "nvim +Man!";
            BROWSER = "firefox";
            EDITOR = "nvim";
            # SHELL = "fish";
            TERMINAL = "kitty";
          };
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

