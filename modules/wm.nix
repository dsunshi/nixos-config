{ ... }: {
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # TODO: Disabling this seems to prevent external monitors from working,
  # therefore for now we keep gnome enabled for simplicity :(
  services.xserver.desktopManager.gnome.enable = true;

  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "colemak_dh_ortho";
  };
}
