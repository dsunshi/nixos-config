{ myUser, inputs, ... }: {
  imports =
    [ inputs.nixos-wsl.nixosModules.default ./../../modules/common.nix ];

  wsl = {
    enable = true;
    defaultUser = myUser.username;
    useWindowsDriver = true; # for the GPU
  };

  nixpkgs.hostPlatform = "x86_64-linux";

  # You do not need to change this if you're reading this in the future.
  # Don't ever change this after the first build.  Don't ask questions.
  system.stateVersion = "24.05";
}
