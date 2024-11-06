{ config, inputs, lib, pkgs, ... }: {
  imports = [
    ./nvim.nix
    ./cli.nix
    ./sh.nix
    ./kitty.nix
    ./picom.nix
    ./xmonad
    ./rofi
    ./wallpaper
    ./xmonad
    ./xmobar
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users = {
      david = {
        programs.direnv.enable = true;
        programs.git = {
          enable = true;
          userName = "D. Sunshine";
          userEmail = "david@sunshines.org";
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
            yt-dlp
            mypaint
            okular
            mypaint-brushes
            prusa-slicer
            gimp
            freetube
            blender
            gpick
            vlc
            flameshot
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

