{ config, inputs, lib, pkgs, ... }: {
  # imports = [ inputs.nix-colors.homeManagerModules.default ];

  # colorScheme = inputs.nix-colors.colorSchemes.catppuccin-macchiato;
  # catppuccin = { flavor = "macchiato"; };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users = {
      david = {
        programs.direnv.enable = true;
        programs.fish.enable = true;
        programs.git = {
          enable = true;
          userName = "D. Sunshine";
          userEmail = "david@sunshines.org";
        };
        programs.kitty = {
          enable = true;
          font = {
            name = "Iosevka NF";
            # package = null;
            size = 14;
          };
          settings = {
            # The basic colors
            foreground = "#cdd6f4";
            background = "#1e1e2e";
            # Cursor colors
            cursor = "#f5e0dc";
            cursor_text_color = "#1e1e2e";
            # The 16 terminal colors
            # black
            color0 = "#45475a";
            color8 = "#585b70";
            # red
            color1 = "#f38ba8";
            color9 = "#f38ba8";
            # green
            color2 = "#a6e3a1";
            color10 = "#a6e3a1";
            # yellow
            color3 = "#f9e2af";
            color11 = "#f9e2af";
            # blue
            color4 = "#89b4fa";
            color12 = "#89b4fa";
            # magenta
            color5 = "#f5c2e7";
            color13 = "#f5c2e7";
            # cyan
            color6 = "#94e2d5";
            color14 = "#94e2d5";
            # white
            color7 = "#bac2de";
            color15 = "#a6adc8";
          };
        };
        home = {
          shellAliases = { vim = "nvim"; };
          # You do not need to change this if you're reading this in the future.
          # Don't ever change this after the first build.  Don't ask questions.
          stateVersion = "24.05";
          packages = with pkgs; [
            zoxide
            lazygit
            calibre
            gnumake
            inputs.nixvim.packages.${system}.default # nixvim
            tmux
            nerdfonts
            yazi
            firefox
            fzf
            ripgrep
          ];
          file.".ghci".text = '':set prompt "λ> "'';
        };
        # catppuccin = {
        #   flavor = "macchiato";
        #   accent = "peach";
        # };
      };
      # You do not need to change this if you're reading this in the future.
      # Don't ever change this after the first build.  Don't ask questions.
      root = _: { home.stateVersion = "24.05"; };
    };
  };
}

