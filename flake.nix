{
  description = "🌞 NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixvim.url = "github:nix-community/nixvim/";
    distro-grub-themes.url = "github:AdisonCavani/distro-grub-themes";
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions/?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { self, nixpkgs, nixvim, home-manager, firefox-addons, agenix, ... }@inputs:
    let
      system = "x86_64-linux";
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
    in {
      nixosConfigurations = {
        bandit = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit (inputs.rycee-nurpkgs.lib) buildFirefoxXpiAddon;
            inherit inputs outputs;
            inherit mySystem;
            inherit myUser;
          };
          modules = [
            nixvim.nixosModules.nixvim
            agenix.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${myUser.username}.imports =
                [ nixvim.homeManagerModules.nixvim ];
            }
            ./modules/home
            ./hosts/bandit
            inputs.distro-grub-themes.nixosModules.${system}.default
          ];
        };
        ghost = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit (inputs.rycee-nurpkgs.lib) buildFirefoxXpiAddon;
            inherit inputs outputs;
            inherit mySystem;
            inherit myUser;
          };
          modules = [
            nixvim.nixosModules.nixvim
            agenix.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${myUser.username}.imports =
                [ nixvim.homeManagerModules.nixvim ];
            }
            ./modules/home
            ./hosts/ghost
          ];
        };
      };
    };
}
