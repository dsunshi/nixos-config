{ myUser, lib, config, pkgs, ... }:
let
  cursor-pkg = pkgs.graphite-cursors;
  cursor-theme = "graphite-dark";
  cursor-size = 24;
  # Wayland does not pay attention .Xdefault or .Xresources so we can call this script to set the cursor ourselves.
  setCursor = pkgs.writeShellScriptBin "set_xcursor" # bash
    ''
      ${pkgs.xorg.xsetroot}/bin/xsetroot -xcf ${cursor-pkg}/share/icons/${cursor-theme}/cursors/default ${
        toString cursor-size
      }
    '';
in {
  config = lib.mkIf config.services.xserver.windowManager.xmonad.enable {
    home-manager.users.${myUser.username} = {
      home = {
        packages = [ setCursor cursor-pkg ];
        sessionVariables = {
          XCURSOR_THEME = cursor-theme;
          XCURSOR_SIZE = cursor-size;
        };
      };

      gtk.cursorTheme.name = cursor-theme;
      gtk.cursorTheme.size = cursor-size;
    };
  };
}
