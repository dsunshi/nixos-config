
all: build

.PHONY: build
build:
	nixos-rebuild build --flake . --impure

.PHONY: install
install:
	nixos-rebuild switch --flake . --impure

.PHONY: clean
clean:
	rm -f flake.lock
	rm -f result

.PHONY: rebuild
rebuild: clean install
