
all: build

.PHONY: build
build:
	nixos-rebuild build --flake .

.PHONY: install
install:
	nixos-rebuild switch --flake .

.PHONY: clean
clean:
	rm -f result

.PHONY: cleanos
cleanos:
	# for home-manager and such
	nix-collect-garbage -d
	# for NixOS itself
	sudo nix-collect-garbage -d
	sudo nix-store --optimise

.PHONY: update
update:
	#nix --extra-experimental-features flakes --extra-experimental-features nix-command flake update
	nix flake update

.PHONY: rebuild
rebuild: update install
