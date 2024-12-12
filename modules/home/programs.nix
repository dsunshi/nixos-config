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
          qbittorrent
          tor-browser
          gimp
          freetube
          blender
          gpick
          vlc
        ];
      };
    };
  };
}
