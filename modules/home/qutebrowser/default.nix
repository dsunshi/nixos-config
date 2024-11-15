{ myUser, pkgs, ... }: {
  home-manager.users.${myUser.username} = {
    home = {
      packages = with pkgs; [ qutebrowser ];
      file.".config/qutebrowser/quickmarks".source = ./quickmarks;
      file.".config/qutebrowser/config.py".source = ./config.py;
    };
  };
}
