{ inputs, pkgs, myUser, ... }: {
  home-manager = {
    users = {
      ${myUser.username} = {
        home = {
          packages = with pkgs; [
            inputs.nixvim.packages.${system}.default # neovim via nixvim
            fzf
            lazygit
            nerdfonts
            nixfmt-classic
            ripgrep
          ];
        };
      };
    };
  };
}

