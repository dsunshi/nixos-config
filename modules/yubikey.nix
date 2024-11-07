{ pkgs, ... }: {
  programs.ssh.startAgent = false;
  services.pcscd.enable = true;
  environment.systemPackages = with pkgs; [
    gnupg
    yubikey-personalization
    yubioath-flutter
    libu2f-host
  ];
  environment.shellInit = ''
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  '';
  services.udev.packages = with pkgs; [ yubikey-personalization ];
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  services.yubikey-agent.enable = true;
}
