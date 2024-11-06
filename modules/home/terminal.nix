{ config, inputs, lib, pkgs, ... }: {
  home-manager.users.david = {
    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
    # Fish as the main shell
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        fish_vi_key_bindings
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
    home = {
      packages = with pkgs; [
        bat
        eza
        tmux
        yazi
        neofetch
        # any-nix-shell # required to have fish as a shell within `nix-shell`
      ];
      shellAliases = {
        vim = "nvim";
        e = "nvim";
        g = "lazygit";
        og = "git";
        q = "exit";
        ls = "exa";
        ll = "exa -alh";
        tree = "exa --tree";
        cat = "bat";
        ".." = "cd ..";
      };
    };
    # Terminal emulator
    programs.kitty = {
      enable = true;
      font = {
        name = "Iosevka NF";
        size = 14;
      };
      # https://github.com/mikesmithgh/kitty-scrollback.nvim
      # extraConfig = ''
      #   scrollback_pager nvim + "source $HOME/.config/kitty/vi-mode.lua"  -c "map q :qa!<CR>"  -c "set clipboard+=unnamedplus"
      #   map alt+s show_scrollback
      #   shell_integration enabled
      # '';
      settings = {
        background_opacity = "0.85";
        background = "#1F1F28";
        foreground = "#DCD7BA";
        selection_background = "#658594";
        selection_foreground = "#c8c093";
        url_color = "#8992a7";
        cursor = "#c8c093";
        # Tabs
        active_tab_background = "#12120f";
        active_tab_foreground = "#C8C093";
        inactive_tab_background = "#12120f";
        inactive_tab_foreground = "#a6a69c";
        #tab_bar_background #15161E";
        # normal
        color0 = "#0d0c0c";
        color1 = "#c4746e";
        color2 = "#8a9a7b";
        color3 = "#c4b28a";
        color4 = "#8ba4b0";
        color5 = "#a292a3";
        color6 = "#8ea4a2";
        color7 = "#C8C093";
        # bright
        color8 = "#a6a69c";
        color9 = "#E46876";
        color10 = "#87a987";
        color11 = "#E6C384";
        color12 = "#7FB4CA";
        color13 = "#938AA9";
        color14 = "#7AA89F";
        color15 = "#c5c9c5";
        # extended colors
        color16 = "#b6927b";
        color17 = "#ff5d62";
      };
    };
  };
}
