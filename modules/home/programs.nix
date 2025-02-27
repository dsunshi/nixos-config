{ myUser, lib, config, pkgs, ... }: {
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
          # https://github.com/NixOS/nixpkgs/issues/348748
          (mypaint.overrideAttrs (oldAttrs: {
            doInstallCheck = false; # Turn off install check
            checkPhase = null; # Disable check phase
          }))
          mypaint-brushes
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
