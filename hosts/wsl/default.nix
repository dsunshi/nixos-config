{ inputs, pkgs, ... }: {
  imports = [ <nixos-wsl/modules> ];

  wsl = {
    enable = true;
    defaultUser = "nixos";
    useWindowsDriver = true;
  };

  nixpkgs.hostPlatform = "x86_64-linux";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  programs.direnv.enable = true;

  environment.variables.EDITOR = "nvim";
  environment.systemPackages = with pkgs; [
    git
    lazygit
    gnumake
    yazi
    # home-manager
    inputs.nixvim.packages.${system}.default
    fzf
    ripgrep
    nixfmt-classic
  ];

  system.stateVersion = "24.05";
}
