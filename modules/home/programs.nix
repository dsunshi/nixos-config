{ myUser, lib, config, pkgs, ... }: {
  config = lib.mkIf (!config.wsl.enable) {
    home-manager.users.${myUser.username} = {
      home = {
        packages = with pkgs; [
          calibre
          gnumake
          mypaint
          okular
          spotify
          mypaint-brushes
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
