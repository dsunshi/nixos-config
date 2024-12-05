{ inputs, pkgs, config, myUser, ... }: {
  imports = [ ./nixvim ];
  home-manager = {
    users = {
      ${myUser.username} = {
        # programs.nixvim.enable = true;
        home = {
          packages = with pkgs;
            [
              # inputs.nixvim.packages.${system}.default # neovim via nixvim
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

