{ config, inputs, lib, pkgs, ... }: {
  home-manager.users.david = {
    home = {
      packages = with pkgs; [
        bat
        eza
        tmux
        yazi
        bottom
        neofetch
        direnv
        nix-direnv
      ];
    };
  };
}
