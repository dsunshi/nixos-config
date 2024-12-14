{ mySystem, lib, pkgs, ... }: {
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.libinput.touchpad.disableWhileTyping = true;
  # TODO: Move to home-manager and add config
  environment.systemPackages = with pkgs;
    [
      (betterlockscreen.overrideAttrs ({ fixupPhase ? "", ... }: {
        fixupPhase = fixupPhase + ''
          ${betterlockscreen}/bin/betterlockscreen -u ~/.config/wallpaper.png
        '';
      }))
    ];
  services.xserver.windowManager.xmonad = lib.mkIf (mySystem.wm == "xmonad") {
    enable = true;
    enableContribAndExtras = true;
    haskellPackages = pkgs.haskell.packages.ghc98;
    extraPackages = hpkgs: [
      hpkgs.xmonad_0_18_0
      hpkgs.xmonad-extras
      hpkgs.xmonad-contrib_0_18_1
    ];
  };

  programs.hyprland = lib.mkIf (mySystem.wm == "hyprland") {
    enable = true;
    xwayland = { enable = true; };
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
