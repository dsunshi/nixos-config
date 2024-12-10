{ config, ... }: {
  config = {
    services.xserver.videoDrivers = [ "displaylink" "nvidia" ];
    hardware = {
      graphics = {
        enable = true;
        # driSupport = true;
        # driSupport32Bit = true;
      };
      nvidia = {
        open = true;
        # package = config.boot.kernelPackages.nvidiaPackages.beta;
        # package = config.boot.kernelPackages.nvidiaPackages.latest;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        # package = config.boot.kernelPackages.nvidiaPackages.legacy_535;
        prime = {
          sync.enable = true;
          # TODO: specialisation?
          # offload = {
          #   enable = true;
          #   enableOffloadCmd = true;
          # };
          # FIXME: Change the following values to the correct Bus ID values for your system!
          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:1:0:0";
        };
        modesetting.enable = true;
        powerManagement.enable = false;
        powerManagement.finegrained = false;
        nvidiaSettings = true;
      };
    };
    # specialisation."displaylink" = {
    #   inheritParentConfig = true;
    #   configuration = {
    #     services.xserver.videoDrivers = [ "nvidia" "displaylink" ];
    #   };
    # };
  };
}
