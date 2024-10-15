{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    # nixvim flake
    nixvim.url = "github:dsunshi/nixvim";
    home-manager = "github:nix-community/home-manager";
  };
  outputs = { self, nixpkgs, nixvim, home-manager, ... }@inputs:
    let inherit (self) outputs;
    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs outputs; };
        # Remainder of the NixOS configuration
        modules =
          [ home-manager.nixosModule ./home-manager ./configuration.nix ];
      };
    };
}
