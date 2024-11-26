{
  description = "🌞 NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixvim.url = "github:dsunshi/nixvim";
    distro-grub-themes.url = "github:AdisonCavani/distro-grub-themes";
  };
  outputs = { self, nixpkgs, nixvim, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      # System Settings
      mySystem = {
        locale = "en_US.UTF-8";
        wm = "xmonad"; # hyprland does **not** work yet!
      };
      # User configuration
      myUser = {
        username = "david";
        name = "D. Sunshine";
        email = "david@sunshines.org";
      };
    in {
      nixosConfigurations = {
        bandit = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = {
            # Pass config variables from above
            inherit inputs outputs;
            inherit mySystem;
            inherit myUser;
          };
          modules = [
            home-manager.nixosModule
            ./modules/home
            ./hosts/bandit
            inputs.distro-grub-themes.nixosModules.${system}.default
          ];
        };
        ghost = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
            inherit mySystem;
            inherit myUser;
          };
          modules = [ home-manager.nixosModule ./modules/home ./hosts/ghost ];
        };
      };
    };
}
