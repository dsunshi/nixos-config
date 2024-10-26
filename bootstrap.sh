#!/usr/bin/env nix-shell
#! nix-shell -p git
#! nix-shell -i bash
if ssh -T git@github.com ; then
  git clone git@github.com:dsunshi/nixos-config.git
else
  git clone --depth 1 https://github.com/dsunshi/nixos-config.git
fi
cd nixos-config
direnv allow # DANGEROUS! You should **not** allow this
sudo nixos-rebuild switch --flake .
