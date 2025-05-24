{ pkgs, config, myUser, ... }: {
  imports = [ ./nixvim ];
  home-manager = {
    users = {
      ${myUser.username} = {
        home = {
          packages = with pkgs;
            [ fzf lazygit nixfmt-classic ripgrep ]
            ++ (if (!config.wsl.enable) then
              [ pkgs.nerd-fonts.iosevka ]
            else
              [ ]);
        };
      };
    };
  };
}
