{
  description = "🌞 NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixvim.url = "github:nix-community/nixvim/";
    distro-grub-themes.url = "github:AdisonCavani/distro-grub-themes";
    secrets.url = "git+ssh://git@github.com/dsunshi/secrets";
    # display-link.url = "git+ssh://git@github.com/dsunshi/displaylink-flake";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
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
  outputs = { self, nixpkgs, nixpkgs-unstable, nixvim, home-manager
    , firefox-addons, agenix, secrets, zen-browser
    , sddm-sugar-candy-nix, ... }@inputs:
    let
      system = "x86_64-linux";
      inherit (self) outputs;
      # System Settings
      mySystem = {
        locale = "en_US.UTF-8";
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
      nixosConfigurations = {
        bandit = nixpkgs.lib.nixosSystem {
          specialArgs = {
            pkgs-unstable = import nixpkgs-unstable { inherit system; };
            inherit self;
            inherit (inputs.firefox-addons.lib.${system}) buildFirefoxXpiAddon;
            inherit inputs outputs;
            inherit mySystem;
            inherit myUser;
          };
          modules = [
            ({ self, ... }: {
              nixpkgs.overlays = [
                # display-link.overlays.default
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
            pkgs-unstable = import nixpkgs-unstable { inherit system; };
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
