{ pkgs, ... }: {
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.libinput.touchpad.disableWhileTyping = true;
  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    haskellPackages = pkgs.haskell.packages.ghc98;
    extraPackages = hpkgs: [
      hpkgs.xmonad_0_18_0
      hpkgs.xmonad-extras
      hpkgs.xmonad-contrib_0_18_1
    ];
  };

  programs.hyprland = {
    enable = true;
    xwayland = { enable = true; };
    # Is dbus needed?
    # Example home-manager: https://github.com/librephoenix/nixos-config/blob/main/user/wm/hyprland/hyprland.nix
    # Further home-manager: https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/
    # repo example: https://github.com/fufexan/dotfiles
  };
  environment.systemPackages = with pkgs; [ wayland waydroid ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    # variant = "colemak_dh_ortho";
  };

}
