{ pkgs, ... }:
let
  post-install-updates = pkgs.writeShellScriptBin "post-install-updates" # bash
    ''
      betterlockscreen -u ~/.config/wallpaper.png
      hoogle generate
      tldr --update
    '';
in {
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = [ post-install-updates ];

  environment.variables.EDITOR = "nvim";
}
