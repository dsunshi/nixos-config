
all: build

.PHONY: build
build:
	nixos-rebuild build --flake . --impure

.PHONY: install
install:
	nixos-rebuild switch --flake . --impure
