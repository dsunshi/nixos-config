{ myUser, pkgs-vintage, lib, config, pkgs, ... }: {
  config = lib.mkIf (!config.wsl.enable) {
    home-manager.users.${myUser.username} = {
      programs.freetube = {
        enable = true;
        settings = {
          allowDashAv1Formats = true;
          checkForUpdates = false;
          baseTheme = "catppuccinMocha";
        };
      };
      home = {
        packages = with pkgs; [
          calibre
          gnumake
          okular
          spotify
          pkgs-vintage.mypaint # https://github.com/NixOS/nixpkgs/issues/348748
          pkgs-vintage.mypaint-brushes
          krita
          prusa-slicer
          fstl
          qbittorrent
          wezterm
          goxel
          leocad
          sweethome3d.application
          tor-browser
          gimp
          anki
          blender
          gpick
          vlc
        ];
      };
    };
  };
}
