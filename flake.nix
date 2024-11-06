{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixvim.url = "github:dsunshi/nixvim";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
  };
  outputs = { self, nixpkgs, nixvim, home-manager, ... }@inputs:
    let inherit (self) outputs;
    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs outputs; };
        modules = [ home-manager.nixosModule ./modules/home ./hosts/nixos ];
      };
    };
}
