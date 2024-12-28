{ pkgs, lib, mySystem, inputs, myUser, config, ... }: {
  config = lib.mkIf mySystem.agenix.enable {
    # Just generate the host key for Agenix
    services.openssh = {
      enable = true;
      openFirewall = false;
      hostKeys = [{
        path = "/etc/ssh/ssh_${config.networking.hostName}_ed25519_key";
        type = "ed25519";
      }];
    };
    environment.systemPackages = with pkgs; [
      inputs.agenix.packages.${pkgs.system}.default
      (inputs.agenix.packages.${pkgs.system}.default.override {
        ageBin = "${pkgs.rage}/bin/rage";
      })
      rage
      xdotool
      age-plugin-yubikey
    ];
    environment.sessionVariables = { };
    age.secrets."expressvpn-key" = {
      file = "${inputs.secrets}/expressvpn.age";
      owner = myUser.username;
    };
    age.secrets."dev.keys" = {
      file = "${inputs.secrets}/dev.keys.age";
      owner = myUser.username;
    };
    age.secrets."prod.keys" = {
      file = "${inputs.secrets}/prod.keys.age";
      owner = myUser.username;
    };
    age.secrets."restic" = {
      file = "${inputs.secrets}/restic.age";
      owner = myUser.username;
    };
    age.secrets."title.keys" = {
      file = "${inputs.secrets}/title.keys.age";
      owner = myUser.username;
    };
  };
}
