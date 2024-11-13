{ inputs, pkgs, config, myUser, ... }: {
  home-manager = {
    users = {
      ${myUser.username} = {
        home = {
          packages = with pkgs;
            [
              inputs.nixvim.packages.${system}.default # neovim via nixvim
              fzf
              lazygit
              nixfmt-classic
              ripgrep
            ] ++ (if (!config.wsl.enable) then [ pkgs.nerdfonts ] else [ ]);
        };
      };
    };
  };
}

