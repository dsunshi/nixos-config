{ myUser, lib, config, pkgs, ... }: {
  config = lib.mkIf (!config.wsl.enable) {
    home-manager.users.${myUser.username} = {
      home = {
        packages = with pkgs; [
          calibre
          gnumake
          okular
          spotify
          # mypaint
          # mypaint-brushes
          prusa-slicer
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
