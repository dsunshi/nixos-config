#!/usr/bin/env nix-shell
#! nix-shell -p git
#! nix-shell -i bash
git clone https://github.com/dsunshi/nixos-config.git
cd nixos-config
nixos-rebuild switch --flake .
