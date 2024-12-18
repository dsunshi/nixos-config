{ myUser, pkgs, config, lib, ... }: {
  config = lib.mkIf (!config.wsl.enable) {
    home-manager.users.${myUser.username} = {
      home = {
        packages = with pkgs; [
          freeciv
          nsz
          kdePackages.kigo
          cataclysm-dda
          legendary-gl
          rare # GUI for ledendary
        ];
      };
    };
  };
}
