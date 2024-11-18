{ myUser, pkgs, config, lib, ... }:
let
  df = pkgs.dwarf-fortress-packages.dwarf-fortress-full.override {
    dfVersion = "0.47.05";
    enableIntro = false;
    enableFPS = true;
    theme = "vettlingr";
    # theme = pkgs.dwarf-fortress-packages.themes.vettlingr;
    # enableTWBT = true;
    # enableTextMode = false;
  };
in {
  config = lib.mkIf (!config.wsl.enable) {
    home-manager.users.${myUser.username} = {
      home = {
        packages = with pkgs; [
          freeciv
          kdePackages.kigo
          cataclysm-dda
          legendary-gl
          rare # GUI for ledendary
          df
          (pkgs.makeDesktopItem {
            name = "dwarf-fortress";
            desktopName = "Dwarf Fortress";
            exec = "dwarf-fortress";
            terminal = false;
          })
        ];
      };
    };
  };
}
