{ pkgs, lib, mySystem, inputs, myUser, ... }:
let
  private = builtins.fetchGit {
    url = "git+ssh://git@github.com/dsunshi/secrets";
    ref = "master";
    rev = "3ee9ac296ad22b2d353e9e09c8d3c693a25c82d4";
    allRefs = true;
  };
in {
  config = lib.mkIf mySystem.agenix.enable {
    services.openssh.enable = true;
    environment.systemPackages =
      [ inputs.agenix.packages.${pkgs.system}.default ];
    age.secrets."expressvpn-key" = {
      file = "${private}/expressvpn.age";
      owner = myUser.username;
    };
  };
}
