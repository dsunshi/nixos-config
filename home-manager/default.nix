{ config, inputs, lib, pkgs, ... }: {
  imports = [ ./terminal.nix ./xmonad.nix ];

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
          packages = with pkgs; [
            any-nix-shell # required to have fish as a shell within `nix-shell`
            calibre
            fzf
            gnumake
            inputs.nixvim.packages.${system}.default # neovim via nixvim
            lazygit
            nerdfonts
            nixfmt-classic
            ripgrep
            tmux
            yt-dlp
            mypaint
            okular
            bat
            mypaint-brushes
            yazi
            eza
            prusa-slicer
            gimp
            blender
            xorg.xmessage
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

