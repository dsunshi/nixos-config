{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixvim.url = "github:dsunshi/nixvim";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
  };
  outputs = { self, nixpkgs, nixvim, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      # System Settings
      mySystem = { locale = "en_US.UTF-8"; };
      # User configuration
      myUser = {
        username = "david";
        name = "D. Sunshine";
        email = "david@sunshines.org";
      };
    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          # Pass config variables from above
          inherit inputs outputs;
          inherit mySystem;
          inherit myUser;
        };
        modules = [ home-manager.nixosModule ./modules/home ./hosts/nixos ];
      };
    };
}
