{ myUser, pkgs, ... }: {
  home-manager.users.${myUser.username}.home = {
    packages = with pkgs; [ rofi-wayland rofi-power-menu rofi-bluetooth ];
    # file.".local/bin/rofi-power-menu".source = ./../bin/rofi-power-menu;
    file.".config/rofi/config.rasi".source = ./config.rasi;
    file.".config/rofi/colorscheme.rasi".source = ./colorscheme.rasi;
  };
}
