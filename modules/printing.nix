{ pkgs, ... }: {
  # TODO: printer config
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ epson-escpr ];
  environment.systemPackages = with pkgs; [ system-config-printer ];
  # Enable autodiscovery of network printers
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  # For scanning
  hardware.sane.extraBackends = [ pkgs.epsonscan2 ];
}
