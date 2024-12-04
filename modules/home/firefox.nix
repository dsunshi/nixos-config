{ myUser, lib, config, pkgs, inputs, ... }: {
  config = lib.mkIf (!config.wsl.enable) {
    home-manager.users.${myUser.username} = {
      programs.firefox = {
        enable = true;
        profiles.${myUser.username} = {
          # NOTE: extensions will have to be enabled individually
          extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
            bitwarden
            darkreader
            sponsorblock
            ublock-origin
            undoclosetabbutton
            gruvbox-dark-theme
            # tridactyl
          ];
        };
      };
    };
  };
}
