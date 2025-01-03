{ myUser, lib, config, buildFirefoxXpiAddon, inputs, ...}:
let
  hoogle-search = buildFirefoxXpiAddon {
    pname = "return-old-github-feed";
    version = "1.2";
    addonId = "{05a4ff46-7c82-4e9d-832c-a6b8554a59c0}";
    url =
      "https://addons.mozilla.org/firefox/downloads/latest/hoogle-search/latest.xpi";
    sha256 = "sha256-A81yWxmPHoOFCIa5E5nBIsGscBvPwyXG0skTsIhiZo8=";
    meta = with lib; {
      homepage = "https://github.com/DRL9/hoogle-search-extension";
      description =
        "To use, type 'hoogle' plus your search term into the url bar. It will search packages in https://hoogle.haskell.org/";
      license = licenses.mpl20;
      platforms = platforms.all;
    };
  };

in {
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
            tridactyl
            hoogle-search
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
            {
              name = "3D Printing Sites";
              toolbar = true;
              bookmarks = [
                {
                  name = "Printables";
                  tags = [ "search" "downloads" ];
                  url = "https://www.printables.com/";
                }
                {
                  name = "Thingiverse";
                  tags = [ "search" "downloads" ];
                  url = "https://www.thingiverse.com/";
                }
                {
                  name = "OpenSCAD Cheatsheet";
                  tags = [ "search" ];
                  url = "https://openscad.org/cheatsheet/";
                }
              ];
            }
          ];
          settings = {
            "browser.startup.homepage" = "about:blank";
            "browser.display.background_color" = "#1F1F28";
            "extensions.autoDisableScopes" =
              0; # Automatically enable extensions
            "browser.newtabpage.activity-stream.showSponsored" = false;
            "browser.newtabpage.activity-stream.system.showSponsored" = false;
            "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          };
        };
        policies = {
          OfferToSaveLogins = false; # This is what bitwarden is for
          DisablePocket = true;
          DisableProfileImport = true;
          DisableTelemetry = true;
          DisableFirefoxStudies = true;
          DontCheckDefaultBrowser = true;
          DisplayBookmarksToolbar =
            "always"; # alternatives: "never" or "newtab"
          DisplayMenuBar =
            "default-off"; # alternatives: "always", "never" or "default-on"
        };
      };
    };
  };
}
