{ myUser, lib, config, pkgs, ... }: {
  config = lib.mkIf (!config.wsl.enable) {
    home-manager.users.${myUser.username} = {
      dconf.settings = {
        "org/gnome/desktop/interface" = { color-scheme = "prefer-dark"; };
      };
      gtk = {
        enable = true;
        theme = {
          name = "Adwaita-dark";
          package = pkgs.gnome-themes-extra;
        };
        iconTheme = {
          name = "Adwaita";
          package = pkgs.adwaita-icon-theme;
        };
        gtk2.extraConfig = "gtk-application-prefer-dark-theme = 1;";
        gtk3.extraConfig = { gtk-application-prefer-dark-theme = 1; };
        gtk4.extraConfig = { gtk-application-prefer-dark-theme = 1; };
      };
      # qt = {
      #   enable = true;
      #   platformTheme = "gnome";
      #   style = "adwaita-dark";
      # };
      home = {
        sessionVariables = {
          GTK_THEME =
            config.home-manager.users.${myUser.username}.gtk.theme.name;
        };
      };
      # Symlink the `~/.config/gtk-4.0/` folder declaratively to theme GTK-4 apps as well.
      xdg.configFile = let
        pkg = config.home-manager.users.${myUser.username}.gtk.theme.package;
        name = config.home-manager.users.${myUser.username}.gtk.theme.name;
      in {
        "gtk-4.0/assets".source = "${pkg}/share/themes/${name}/gtk-4.0/assets";
        "gtk-4.0/gtk.css".source =
          "${pkg}/share/themes/${name}/gtk-4.0/gtk.css";
        "gtk-4.0/gtk-dark.css".source =
          "${pkg}/share/themes/${name}/gtk-4.0/gtk-dark.css";
      };
    };
  };
}
