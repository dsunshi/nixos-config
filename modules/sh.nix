{ pkgs, ... }: {
  # Use fish as the main system shell
  programs.fish = { enable = true; };

  # It is not possible on Nix to have fish be the login shell. Therefore ...
  # as per: https://fishshell.com/docs/current/index.html#default-shell
  programs.bash = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };
}
