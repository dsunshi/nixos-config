{ pkgs, ... }: {
  programs.ssh.startAgent = false;
  services.pcscd.enable = true;
  environment.systemPackages = with pkgs; [
    yubikey-personalization
    yubioath-flutter
    libu2f-host
  ];
  services.udev.packages = with pkgs; [ yubikey-personalization ];
  services.yubikey-agent.enable = true;
}
