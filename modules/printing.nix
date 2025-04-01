{ pkgs, ... }: {
  # TODO: printer config
  services.printing.enable = true;
  # ptouch-driver and ptouch-print are for PT-P710BT
  services.printing.drivers = with pkgs; [ epson-escpr ptouch-driver ];
  environment.systemPackages = with pkgs; [
    system-config-printer
    ptouch-print
  ];
  # Enable autodiscovery of network printers
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  # For scanning
  hardware.sane.extraBackends = [ pkgs.epsonscan2 ];
}
