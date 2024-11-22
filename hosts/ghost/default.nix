{ myUser, inputs, ... }:
let hostname = "ghost";
in {
  imports = [
    inputs.nixos-wsl.nixosModules.default
    ./../../modules/common.nix
    ./../../modules/sh.nix
  ];

  wsl = {
    enable = true;
    defaultUser = myUser.username;
    useWindowsDriver =
      true; # Whether to enable OpenGL driver from the Windows host.
    wslConf.network.hostname = hostname;
  };
  networking.hostName = hostname;

  nixpkgs.hostPlatform = "x86_64-linux";

  # You do not need to change this if you're reading this in the future.
  # Don't ever change this after the first build.  Don't ask questions.
  system.stateVersion = "24.05";
}
