{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ distrobox ];
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
}
