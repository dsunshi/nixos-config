#!/usr/bin/env nix-shell
#! nix-shell -p git
#! nix-shell -i bash
git clone https://github.com/dsunshi/nixos-config.git
cd nixos-config
direnv allow # DANGEROUS! You should **not** allow this
sudo nixos-rebuild switch --flake .
