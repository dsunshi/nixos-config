
all: build

.PHONY: build
build:
	nixos-rebuild build --flake .

.PHONY: install
install:
	nixos-rebuild switch --flake .

.PHONY: clean
clean:
	rm -f flake.lock
	rm -f result

.PHONY: update
update:
	#nix --extra-experimental-features flakes --extra-experimental-features nix-command flake update
	nix flake update

.PHONY: rebuild
rebuild: update install
