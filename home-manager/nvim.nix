{ config, inputs, lib, pkgs, ... }: {
  home-manager = {
    users = {
      david = {
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

