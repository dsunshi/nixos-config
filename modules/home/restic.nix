{ myUser, lib, config, ... }:
let password = config.age.secrets."restic".path;
in {
  config = lib.mkIf (!config.wsl.enable) {
    services.restic.backups = {
      bandit-backup = {
        # initialize = true; # Initialize the repo if it does not exist
        repository = "/run/media/${myUser.username}/6636-6561/bandit-backup";
        # user = "${myUser.username}";
        passwordFile = "${password}";
        paths = [
          "/home/${myUser.username}/Music/"
          "/home/${myUser.username}/programming/"
          # "/home/${myUser.username}/Backup"
          "/home/${myUser.username}/Documents/"
          "/home/${myUser.username}/Videos/"
          "/home/${myUser.username}/Darkroom/"
          "/home/${myUser.username}/Games/"
          "/home/${myUser.username}/CalibreLibrary/"
          "/home/${myUser.username}/Pictures/"
          "/home/${myUser.username}/Downloads/"
        ];
        # dynamicFilesFrom = # bash
        #   ''
        #     find /home/${myUser.username}/ -maxdepth 1 -not -empty -not -path "*/.*" -type d | tail -n +2
        #   '';
        pruneOpts = [ "--keep-last 3" ];
        # extraBackupArgs = [ "--exclude-file=/home/${myUser.username}/tmp/" ];
        # timerConfig = {
        #   OnCalendar = "daily";
        #   Persistent = true;
        # };
      };
    };
  };
}
