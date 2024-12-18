{ myUser, lib, config, pkgs, ... }:
let
  bandit = ".config/.bandit.png";
  background = ".config/.background.png";
  wallpaper = ".config/wallpaper.png";
  walk-bandit = pkgs.writeShellScriptBin "walk-bandit" # bash
    ''
      USER=/home/${myUser.username}
      bg=$USER/${background}
      # 870 x 1353
      bandit=$USER/${bandit}
      fout=$USER/${wallpaper}

      if [ "$#" -eq 1 ]; then
        Q=$1
      else
        r=$((1 + RANDOM % 10))
        if ((r >= 1 && r <= 4)); then
          Q=4
        elif ((r >= 5 && r <= 8)); then
          Q=1
        elif ((r == 9)); then 
          Q=2
        else
          Q=3
        fi
      fi

      mirror=mktemp

      if [[ Q -eq 4 ]]; then
        magick $bandit -flop $mirror
        magick $bg $mirror -gravity SouthEast -geometry '434x676-140-400' -composite $fout
      fi
      if [[ Q -eq 3 ]]; then
        magick $bg $bandit -gravity SouthWest -geometry '434x676-140-400' -composite $fout
      fi
      if [[ Q -eq 2 ]]; then
        magick $bandit -flip $mirror
        magick $bg $mirror -gravity NorthWest -geometry '434x676-140-400' -composite $fout
      fi
      if [[ Q -eq 1 ]]; then
        magick $bandit -flip -flop $mirror
        magick $bg $mirror -gravity NorthEast -geometry '434x676-140-400' -composite $fout
      fi

      rm -rf $mirror
      feh --bg-scale --no-fehbg $fout
    '';
in {
  config = lib.mkIf config.services.xserver.windowManager.xmonad.enable {
    environment.systemPackages = with pkgs; [ imagemagick walk-bandit feh ];
    home-manager.users.${myUser.username}.home = {
      packages = with pkgs;
        [
          feh # sets the wallpaper
        ];
      # file.".config/wallpaper.png".source = ./wallpaper.png;
      file."${bandit}".source = ./bandit.png;
      file."${background}".source = ./background.png;
    };
  };
}
