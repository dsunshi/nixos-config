
.PHONY: all
all:
	nixos-rebuild dry-activate --flake . --impure

.PHONY: install
install:
	nixos-rebuild switch --flake . --impure
