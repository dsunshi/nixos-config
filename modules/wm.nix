{ mySystem, lib, ... }: {
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.libinput.touchpad.disableWhileTyping = true;

  services.xserver.windowManager.xmonad = lib.mkIf (mySystem.wm == "xmonad") {
    enable = true;
    enableContribAndExtras = true;
  };

  programs.hyprland = lib.mkIf (mySystem.wm == "hyprland") {
    enable = true;
    xwayland = {
      enable = true;
    };
    # environment.systemPackages = with pkgs; [ wayland waydroid ];
    # Is dbus needed?
    # services.dbus = {
    #   enable = true;
    #   packages = [ pkgs.dconf ];
    # };
    # Example home-manager: https://github.com/librephoenix/nixos-config/blob/main/user/wm/hyprland/hyprland.nix
    # Further home-manager: https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/
    # repo example: https://github.com/fufexan/dotfiles
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "colemak_dh_ortho";
  };
  
}
