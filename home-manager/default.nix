{ lib, pkgs, ... }: {
  home = {
    packages = with pkgs; [
      hello
      # Doesn't matter if they're on new lines or not,
      # they just need whitespace between them
      cowsay
      lolcat
    ];

    # This needs to actually be set to your username
    username = "david";
    homeDirectory = "/home/david";

    # Don't ever change this after the first build.  Don't ask questions.
    stateVersion = "24.05";
  };
}
