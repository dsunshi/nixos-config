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
  programs.xss-lock = {
    enable = true;
    lockerCommand = "${pkgs.betterlockscreen}/bin/betterlockscreen --lock blur";
    # lock before suspending/hibernating, see https://github.com/i3/i3lock/issues/207
    extraOptions = [ "--transfer-sleep-lock" ];
  };
  programs.hyprland = {
    enable = true;
    xwayland = { enable = true; };
    # TODO: is dbus needed?
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
