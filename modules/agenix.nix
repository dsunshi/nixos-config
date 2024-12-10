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
      (inputs.agenix.packages.${pkgs.system}.default.override {
        ageBin = "${pkgs.rage}/bin/rage";
      })
      rage
    ];
    environment.sessionVariables = { };
    age.secrets."expressvpn-key" = {
      file = "${inputs.secrets}/expressvpn.age";
      owner = myUser.username;
    };
  };
}
