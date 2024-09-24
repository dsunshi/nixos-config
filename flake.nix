{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    # nixvim flake
    nixvim.url = "github:dsunshi/nixvim";
  };
  outputs = { self, nixpkgs, nixvim, ... }@inputs:
    let inherit (self) outputs;
    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs outputs; };
        # Remainder of the NixOS configuration
        modules = [ ./configuration.nix ];
      };
    };
}
