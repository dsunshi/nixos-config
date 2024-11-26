
DISPLAYLINK=./depends/displaylink-600.zip

all: test

.PHONY: test
test:
ifneq ("$(wildcard $(DISPLAYLINK))", "")
	@echo "[INFO]: enabling displaylink"
	nix-prefetch-url file://$(shell pwd)/$(DISPLAYLINK)
	nh os test -s displaylink
else
	@echo "[WARN]: disabling displaylink"
	nh os test
endif

.PHONY: install
install:
ifneq ("$(wildcard $(DISPLAYLINK))", "")
	@echo "[INFO]: enabling displaylink"
	nix-prefetch-url file://$(shell pwd)/$(DISPLAYLINK)
	nh os switch -s displaylink .
else
	@echo "[WARN]: disabling displaylink"
	nh os switch .
endif

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
