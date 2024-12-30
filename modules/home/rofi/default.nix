{ myUser, lib, config, pkgs, ... }:
# let
#   my-power-menu = pkgs.rofi-power-menu.overrideAttrs
#     (finalAttrs: previousAttrs: {
#       installPhase = previousAttrs.installPhase + "\n" + ''
#         ${pkgs.sd}/bin/sd -F "loginctl lock-session \$''${XDG_SESSION-}" "loginctl lock-sessions" $out/bin/rofi-power-menu
#         ${pkgs.sd}/bin/sd -F "sessions{XDG_SESSION_ID-}" "sessions" $out/bin/rofi-power-menu
#       '';
#     });
# in
{
  config = lib.mkIf config.services.xserver.windowManager.xmonad.enable {
    home-manager.users.${myUser.username}.home = {
      packages = with pkgs; [
        rofi-wayland
        rofi-power-menu
        # my-power-menu
        rofi-bluetooth
        rofi-pulse-select
      ];
      file.".config/rofi/config.rasi".source = ./config.rasi;
      file.".config/rofi/colorscheme.rasi".source = ./colorscheme.rasi;
    };
  };
}
