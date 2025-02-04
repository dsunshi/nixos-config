{ myUser, pkgs, lib, config, ... }:
let
  reverse = pkgs.writeShellScriptBin "switch-monitors" # bash
    ''
      hyprctl keyword monitor DVI-I-2, 1920x1080, 1920x0, 1
      hyprctl keyword monitor DVI-I-1, 1920x1080, 0x0, 1
      hyprctl keyword monitor eDP-1, 1920x1200, 3840x1080, 1
    '';
in {
  config = lib.mkIf config.programs.hyprland.enable {
    home-manager.users.${myUser.username} = {
      # https://github.com/librephoenix/nixos-config/blob/main/user/wm/hyprland/hyprland.nix
      home = {
        packages = with pkgs; [ libva-utils libinput-gestures reverse ];
      };
      wayland.windowManager.hyprland = {
        enable = true;
        settings = {
          "$mod" = "SUPER";
          bind = [
            "$mod SHIFT, q, exec, rofi -show power-menu -modi power-menu:rofi-power-menu"
            "$mod SHIFT, c, killactive"
            "$mod, p, exec, rofi -show drun"
            "$mod SHIFT, Return, exec, kitty"
            "$mod, 1, workspace, 1"
            "$mod, 2, workspace, 2"
            "$mod, 3, workspace, 3"
            "$mod, 4, workspace, 4"
            "$mod, 5, workspace, 5"
            "$mod, 6, workspace, 6"
            "$mod, 7, workspace, 7"
            "$mod, 8, workspace, 8"
            "$mod, 9, workspace, 9"
            "$mod SHIFT, 1, movetoworkspace, 1"
            "$mod SHIFT, 2, movetoworkspace, 2"
            "$mod SHIFT, 3, movetoworkspace, 3"
            "$mod SHIFT, 4, movetoworkspace, 4"
            "$mod SHIFT, 5, movetoworkspace, 5"
            "$mod SHIFT, 6, movetoworkspace, 6"
            "$mod SHIFT, 7, movetoworkspace, 7"
            "$mod SHIFT, 8, movetoworkspace, 8"
            "$mod SHIFT, 9, movetoworkspace, 9"
            # Move focus with SUPER + arrow keys
            "$mod, left, movefocus, l"
            "$mod, down, movefocus, d"
            "$mod, up, movefocus, u"
            "$mod, right, movefocus, r"
            "$mod, n, togglespecialworkspace"
            "$mod SHIFT, n, movetoworkspace, special"
          ];
        };
        extraConfig = ''
          exec-once = swww-daemon &
          exec-once = walk-bandit
          # exec-once = waybar & hyprpaper

          monitor = DVI-I-1, 1920x1080, 1920x0, 1
          monitor = DVI-I-2, 1920x1080, 0x0, 1
          monitor = eDP-1, 1920x1200, 3840x1080, 1

          # https://wiki.hyprland.org/Configuring/Variables/#general
          general {
            gaps_in = 4
            gaps_out = 8

            border_size = 2

            # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
            col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
            col.inactive_border = rgba(595959aa)

            # Set to true enable resizing windows by clicking and dragging on borders and gaps
            resize_on_border = false

            # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
            allow_tearing = false

            layout = dwindle
          }

          # https://wiki.hyprland.org/Configuring/Variables/#decoration
          decoration {
            rounding = 8

            # Change transparency of focused and unfocused windows
            active_opacity = 1.0
            inactive_opacity = 1.0

            shadow {
              enabled = true
              range = 4
              render_power = 3
              color = rgba(1a1a1aee)
            }

            # https://wiki.hyprland.org/Configuring/Variables/#blur
            blur {
              enabled = true
              size = 3
              passes = 1

              vibrancy = 0.1696
            }
          }

          # https://wiki.hyprland.org/Configuring/Variables/#animations
          animations {
            enabled = true

            # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

            bezier = myBezier, 0.05, 0.9, 0.1, 1.05

            animation = windows, 1, 7, myBezier
            animation = windowsOut, 1, 7, default, popin 80%
            animation = border, 1, 10, default
            animation = borderangle, 1, 8, default
            animation = fade, 1, 7, default
            animation = workspaces, 1, 6, default
          }

          # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
          dwindle {
            # TODO:
            pseudotile = true # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
            preserve_split = true # You probably want this
          }
        '';
      };
    };
  };
}
