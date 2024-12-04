{ myUser, lib, config, pkgs, inputs, ... }: {
  config = lib.mkIf (!config.wsl.enable) {
    home-manager.users.${myUser.username} = {
      programs.firefox = {
        enable = true;
        profiles.${myUser.username} = {
          extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
            bitwarden
            darkreader
            sponsorblock
            ublock-origin
            undoclosetabbutton
            gruvbox-dark-theme
            # tridactyl
          ];
          bookmarks = [
            {
              name = "Haskell Sites";
              toolbar = true;
              bookmarks = [
                {
                  name = "Hackage";
                  tags = [ "search" "nix" "packages" ];
                  url = "https://hackage.haskell.org/";
                }
                {
                  name = "hoogle";
                  tags = [ "search" "haskell" ];
                  url = "https://hoogle.haskell.org/";
                }
              ];
            }
            {
              name = "Nix Sites";
              toolbar = true;
              bookmarks = [
                {
                  name = "NixVim Options";
                  tags = [ "neovim" "nix" ];
                  url = "https://nix-community.github.io/nixvim/";
                }
                {
                  name = "Nix Packages";
                  tags = [ "search" "nix" "packages" ];
                  url = "https://search.nixos.org/packages";
                }
                {
                  name = "NixOS Wiki";
                  tags = [ "wiki" "nix" ];
                  url = "https://wiki.nixos.org/";
                }
                {
                  name = "Home Manager Options";
                  tags = [ "wiki" "nix" ];
                  url =
                    "https://nix-community.github.io/home-manager/options.xhtml";
                }
              ];
            }
          ];
          settings = {
            "browser.startup.homepage" = "about:blank";
            "browser.display.background_color" = "#1F1F28";
          };
        };
        policies = {
          OfferToSaveLogins = false; # This is what bitwarden is for
          DisablePocket = true;
          DisableProfileImport = true;
        };
      };
    };
  };
}
