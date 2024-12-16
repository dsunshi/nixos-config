{ pkgs }:
let
  image = pkgs.fetchurl {
    url =
      "https://github.com/dsunshi/nixos-config/blob/master/modules/home/wallpaper/wallpaper.png?raw=true";
    sha256 = "sha256-M+z5PMnpAIypEz0r5Wf8r1wWFe8OrQ/bXraVq59ecyQ=";
  };
in pkgs.stdenv.mkDerivation {
  name = "sddm-theme";

  src = pkgs.fetchFromGitHub {
    owner = "MarianArlt";
    repo = "sddm-sugar-dark";
    rev = "ceb2c455663429be03ba62d9f898c571650ef7fe";
    sha256 = "0153z1kylbhc9d12nxy9vpn0spxgrhgy36wy37pk6ysq7akaqlvy";
  };
  installPhase = # bash
    ''
      mkdir -p $out
      cp -R ./* $out/
      cd $out/
      rm Background.jpg
      cp -r ${image} $out/Background.jpg
    '';
}

