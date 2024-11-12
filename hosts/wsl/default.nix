{ myUser, inputs, pkgs, ... }: {
  imports = [ inputs.nixos-wsl.nixosModules.default ];

  wsl = {
    enable = true;
    defaultUser = myUser.username;
    useWindowsDriver = true;
  };

  nixpkgs.hostPlatform = "x86_64-linux";

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  programs.direnv.enable = true;

  environment.variables.EDITOR = "nvim";
  environment.systemPackages = with pkgs; [
    git
    lazygit
    gnumake
    yazi
    home-manager
    inputs.nixvim.packages.${system}.default
    fzf
    ripgrep
    nixfmt-classic
  ];

  system.stateVersion = "24.05";
}
