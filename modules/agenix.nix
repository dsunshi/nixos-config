{ pkgs, lib, mySystem, inputs, myUser, ... }:
let
  private = builtins.fetchGit {
    url = "git+ssh://git@github.com/dsunshi/secrets";
    ref = "master";
    rev = "fcf5ced4418eb380253fd88311e54ac6b8b9f9ab";
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
