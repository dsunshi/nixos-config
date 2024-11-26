{ myUser, lib, config, pkgs, ... }:
 {
  config = lib.mkIf config.programs.hyprland.enable {
    home-manager.users.${myUser.username} = {
      home = {
          wayland.windowManager.hyprland.enable = true;
          wayland.windowManager.hyprland.settings = {
            "$mod" = "SUPER";
            bind =
              [
                "$mod, F, exec, firefox"
                "$mod, k, exec, kitty"
                "$mod SHIFT, Return, exec, kitty"
              ];
          };
        };
      };
  };
}
