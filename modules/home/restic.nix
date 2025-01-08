{ myUser, lib, config, ... }:
let password = config.age.secrets."restic".path;
in {
  config = lib.mkIf (!config.wsl.enable) {
    services.restic.backups = {
      bandit-daily = {
        initialize = true; # Initialize the repo if it does not exist
        repository = "/run/media/${myUser.username}/6636-6561/bandit-daily";
        # user = "${myUser.username}";
        passwordFile = "${password}";
        paths = [
          "/home/${myUser.username}/programming/"
          "/home/${myUser.username}/Documents/"
          "/home/${myUser.username}/.nb/"
        ];
        pruneOpts = [ "--keep-last 7" ];
        timerConfig = {
          OnCalendar = "daily";
          Persistent = true;
        };
      };
      bandit-weekly = {
        initialize = true; # Initialize the repo if it does not exist
        repository = "/run/media/${myUser.username}/6636-6561/bandit-weekly";
        passwordFile = "${password}";
        paths = [
          "/home/${myUser.username}/Darkroom/"
          "/home/${myUser.username}/CalibreLibrary/"
          "/home/${myUser.username}/Pictures/"
        ];
        pruneOpts = [ "--keep-last 4" ];
        timerConfig = {
          OnCalendar = "weekly";
          Persistent = true;
        };
      };
      bandit-monthly = {
        initialize = true; # Initialize the repo if it does not exist
        repository = "/run/media/${myUser.username}/6636-6561/bandit-monthly";
        passwordFile = "${password}";
        paths = [
          "/home/${myUser.username}/Music/"
          "/home/${myUser.username}/Backup"
          "/home/${myUser.username}/Videos/"
          "/home/${myUser.username}/Games/"
          "/home/${myUser.username}/Downloads/"
          "/home/${myUser.username}/.local/share/applications/"
        ];
        pruneOpts = [ "--keep-last 6" ];
        timerConfig = {
          OnCalendar = "monthly";
          Persistent = true;
        };
      };
    };
  };
}
