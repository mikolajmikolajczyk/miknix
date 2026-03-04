NIX_EXPERIMENTAL_FLAGS = --extra-experimental-features nix-command --extra-experimental-features flakes
NIX_FLAGS ?=
NIX_BUILD_FLAGS = $(NIX_EXPERIMENTAL_FLAGS) $(NIX_FLAGS)

.PHONY: help flake-update rebuild-laptop

help:
	@echo "Targets:"
	@echo "  flake-update    Update flake.lock inputs"
	@echo "  rebuild-laptop  Rebuild and switch NixOS for #laptop"

flake-update:
	nix flake update $(NIX_BUILD_FLAGS)

rebuild-laptop:
	sudo nixos-rebuild switch --flake .#laptop
