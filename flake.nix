{
  description = "🌞 NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixvim.url = "github:nix-community/nixvim/";
    distro-grub-themes.url = "github:AdisonCavani/distro-grub-themes";
    secrets.url = "git+ssh://git@github.com/dsunshi/secrets";
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions/?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sddm-sugar-candy-nix = {
      url = "gitlab:Zhaith-Izaliel/sddm-sugar-candy-nix";
      # Optional, by default this flake follows nixpkgs-unstable.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, nixvim, home-manager, firefox-addons, agenix
    , secrets, sddm-sugar-candy-nix, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      displaylink_src = pkgs.fetchurl {
        url =
          "https://www.synaptics.com/sites/default/files/exe_files/2024-05/DisplayLink%20USB%20Graphics%20Software%20for%20Ubuntu6.0-EXE.zip";
        name = "displaylink-600.zip";
        hash = "sha256-/HqlGvq+ahnuBCO3ScldJCZp8AX02HM8K4IfMzmducc=";
      };
      inherit (self) outputs;
      # System Settings
      mySystem = {
        locale = "en_US.UTF-8";
        wm = "xmonad"; # hyprland does **not** work yet!
        agenix.enable = true;
      };
      # User configuration
      myUser = {
        username = "david";
        name = "D. Sunshine";
        email = "david@sunshines.org";
      };
      sharedModules = [
        nixvim.nixosModules.nixvim
        agenix.nixosModules.age
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${myUser.username}.imports =
            [ nixvim.homeManagerModules.nixvim ];
        }
        ./modules/home
      ];
    in {
      displaylink_overlay = (final: prev: {
        displaylink =
          prev.displaylink.overrideAttrs (new: old: { src = displaylink_src; });
      });
      nixosConfigurations = {
        bandit = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit self;
            inherit (inputs.firefox-addons.lib.${system}) buildFirefoxXpiAddon;
            inherit inputs outputs;
            inherit mySystem;
            inherit myUser;
          };
          modules = [
            ({ self, ... }: {
              nixpkgs.overlays = [
                self.displaylink_overlay
                sddm-sugar-candy-nix.overlays.default
              ];
            })
            ./hosts/bandit
            inputs.distro-grub-themes.nixosModules.${system}.default
            sddm-sugar-candy-nix.nixosModules.default
          ] ++ sharedModules;
        };
        ghost = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit (inputs.rycee-nurpkgs.lib) buildFirefoxXpiAddon;
            inherit inputs outputs;
            inherit mySystem;
            inherit myUser;
          };
          modules = [ ./hosts/ghost ] ++ sharedModules;
        };
      };
    };
}
