{ pkgs, ... }:
let
  post-install-updates = pkgs.writeShellScriptBin "post-install-updates" # bash
    ''
      betterlockscreen -u ~/.config/wallpaper.png
      hoogle generate --download
      tldr --update
    '';
in {
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = [ post-install-updates ];
  nix.settings.download-buffer-size = 100663296;

  environment.variables.EDITOR = "nvim";
}
