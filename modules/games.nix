{ pkgs, config, lib, ... }: {
  config = lib.mkIf (!config.wsl.enable) {
    environment.systemPackages = with pkgs; [
      # lutris
      # bottles
      # Wine
      wine64
      winetricks
      # native wayland support (unstable)
      wineWowPackages.waylandFull
    ];
    programs.gamemode.enable = true;
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall =
        true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall =
        true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall =
        true; # Open ports in the firewall for Steam Local Network Game Transfers
    };
  };
}
