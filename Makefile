
all: build

.PHONY: build
build:
	nixos-rebuild build --flake .

.PHONY: install
install:
	# nix-prefetch-url file://$(shell pwd)/depends/displaylink-580.zip
	nixos-rebuild switch --flake .

.PHONY: clean
clean:
	rm -f result

.PHONY: cleanos
cleanos:
	# optimize before garbage collection (this can take a while, so be prepared)
	nix-store --optimise
	sudo nix-store --optimise
	# for home-manager and such
	nix-collect-garbage -d
	# for NixOS itself
	sudo nix-collect-garbage -d

.PHONY: update
update:
	#nix --extra-experimental-features flakes --extra-experimental-features nix-command flake update
	nix flake update

.PHONY: rebuild
rebuild: update install
