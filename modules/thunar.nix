{ pkgs, ... }: {
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [ thunar-archive-plugin thunar-volman ];
  };
  programs.xfconf.enable = true; # allow saving config outside of xfce
  programs.dconf.enable = true; # Must be present for any desktop GTK apps
  services.gvfs.enable = true; # Mount, trash, and other functionalities
}
