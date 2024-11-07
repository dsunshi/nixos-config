{ myUser, pkgs, ... }: {
  home-manager.users.${myUser.username} = {
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
