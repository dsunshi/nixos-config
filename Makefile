
all: build

.PHONY: build
build:
	nixos-rebuild build --flake .#nixos

.PHONY: install
install:
	# nix-prefetch-url file://$(shell pwd)/depends/displaylink-580.zip
	nixos-rebuild switch --flake .#nixos

.PHONY: clean
clean:
	unlink ./result

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
ifneq ($(shell id -u), 0)
	#nix --extra-experimental-features flakes --extra-experimental-features nix-command flake update
	nix flake update
else
	@echo "WARN: update CANNOT be run as the root user! Skipping ..."
endif
