{ config, inputs, lib, pkgs, ... }: {
  home-manager.users.david = {
    # Fish as the main shell
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # Disable greeting
      '';
      # ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
      functions = {
        haskellEnv = ''
          nix-shell -p "haskellPackages.ghcWithPackages (pkgs: with pkgs; [ $argv ])"'';
      };
      plugins = [
        {
          name = "pure";
          src = pkgs.fishPlugins.pure.src;
        }
        {
          name = "fzf";
          src = pkgs.fishPlugins.fzf-fish.src;
        }
      ];
    };
    # Shell alliases
    home = { shellAliases = { vim = "nvim"; }; };
    # Terminal emulator
    programs.kitty = {
      enable = true;
      font = {
        name = "Iosevka NF";
        # package = null;
        size = 14;
      };
      settings = {
        background_opacity = "0.8";
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
  };
}
