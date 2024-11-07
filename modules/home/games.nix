{ myUser, pkgs, ... }:
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
  home-manager.users.${myUser.username} = {
    # programs.steam = {
    #   enable = true;
    #   remotePlay.openFirewall =
    #     true; # Open ports in the firewall for Steam Remote Play
    #   dedicatedServer.openFirewall =
    #     true; # Open ports in the firewall for Source Dedicated Server
    #   localNetworkGameTransfers.openFirewall =
    #     true; # Open ports in the firewall for Steam Local Network Game Transfers
    # };
    home = {
      packages = with pkgs; [
        freeciv
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
}
