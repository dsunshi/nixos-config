{ config, lib, inputs, pkgs, ... }: {
  imports = [ <nixos-wsl/modules> ];

  wsl.enable = true;
  wsl.defaultUser = "nixos";
  wsl.useWindowsDriver = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  programs.direnv.enable = true;

  environment.variables.EDITOR = "nvim";
  environment.systemPackages = with pkgs; [
    git
    lazygit
    gnumake
    tmux
    hexyl
    tmux
    yazi
    inputs.nixvim.packages.${system}.default # nixvim
    fzf
    ripgrep
    nixfmt-classic
  ];

  system.stateVersion = "24.05";
}
