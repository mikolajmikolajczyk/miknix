# Guide: Add a New Host and Mix Modules

This repo separates reusable modules from host-specific wiring:

- Reusable system modules: `modules/system/*`
- Reusable home modules: `modules/home/*`
- Host entrypoint: `hosts/<host>/configuration.nix`
- Host-only modules (example mounts): `hosts/laptop/storage.nix`

## 1) Create host files

Create:
- `hosts/<host>/configuration.nix`
- `hosts/<host>/hardware-configuration.nix`
- optional host-only modules like `hosts/<host>/storage.nix`

Start by copying `hosts/laptop/configuration.nix` and remove modules you do not need.

## 2) Register host in `flake.nix`

Add to `nixosConfigurations`:

```nix
<host> = mkSystem [
  ./hosts/<host>/configuration.nix
];
```

## 3) Choose modules per host

In `hosts/<host>/configuration.nix`, include only what that machine needs:

- Always useful: `secrets.nix`, `base.nix`, `networking.nix`, `dev.nix`
- Laptop-ish: `audio.nix`, `desktop-wayland.nix`, `nvidia.nix`
- Optional: `gaming.nix`, `backup.nix`, host-specific `storage.nix`

This keeps modules composable and avoids one giant monolithic config.

## 4) Host secrets

Set per-host secrets path, for example:

```nix
miknix.secretsDir = "${config.miknix.user.home}/data/nix_secrets/<host>";
```

Then create required files at that location (wifi, smb, restic, git, etc.).

## 5) Build and test

```bash
sudo nixos-rebuild switch --flake .#<host>
```

Useful checks:

```bash
nixos-rebuild dry-build --flake .#<host>
rg -n "miknix\.user|miknix\.secretsDir" hosts modules
```
