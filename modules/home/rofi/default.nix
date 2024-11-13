{ myUser, lib, config, pkgs, ... }: {
  config = lib.mkIf config.services.xserver.windowManager.xmonad.enable {
    home-manager.users.${myUser.username}.home = {
      packages = with pkgs; [ rofi-wayland rofi-power-menu rofi-bluetooth ];
      file.".config/rofi/config.rasi".source = ./config.rasi;
      file.".config/rofi/colorscheme.rasi".source = ./colorscheme.rasi;
    };
  };
}
