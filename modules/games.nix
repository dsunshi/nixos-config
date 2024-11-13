{ pkgs, config, lib, ... }: {
  config = lib.mkIf (!config.wsl.enable) {
    environment.systemPackages = with pkgs; [
      lutris
      # Wine
      # support both 32- and 64-bit applications
      wineWowPackages.stable
      # support 32-bit only
      # wine
      # support 64-bit only
      # (wine.override { wineBuild = "wine64"; })
      # support 64-bit only
      # wine64
      # wine-staging (version with experimental features)
      wineWowPackages.staging
      # winetricks (all versions)
      winetricks
      # native wayland support (unstable)
      wineWowPackages.waylandFull
    ];
    programs.steam = {
      enable = true;
      remotePlay.openFirewall =
        true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall =
        true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall =
        true; # Open ports in the firewall for Steam Local Network Game Transfers
    };
    # Needed for the Epic game store
    hardware.opengl.driSupport32Bit = true;
  };
}
