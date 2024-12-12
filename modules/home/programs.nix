{ myUser, lib, config, pkgs, ... }: {
  config = lib.mkIf (!config.wsl.enable) {
    home-manager.users.${myUser.username} = {
      home = {
        packages = with pkgs; [
          calibre
          gnumake
          okular
          spotify
          # mypaint # https://github.com/NixOS/nixpkgs/issues/348748
          # mypaint-brushes
          krita
          prusa-slicer
          fstl
          qbittorrent
          tor-browser
          gimp
          anki
          freetube
          blender
          gpick
          vlc
        ];
      };
    };
  };
}
