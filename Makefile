
all: install

.PHONY: test
test:
	nh os test

.PHONY: install
install:
	nh os switch .

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
	# Using nh
	nh clean all

.PHONY: update
update:
ifneq ($(shell id -u), 0)
	nix flake update
else
	@echo "[WARN]: update CANNOT be run as the root user! Skipping ..."
endif
