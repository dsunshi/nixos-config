{ pkgs, ... }: {
  services.usbmuxd.enable = true;

  environment.systemPackages = with pkgs; [
    libimobiledevice
    ifuse # to mount using 'ifuse'
  ];

  # If problems described here: https://github.com/NixOS/nixpkgs/issues/152592
  # try this:
  # services.usbmuxd = {
  #   enable = true;
  #   package = pkgs.usbmuxd2;
  # };
}
