# Laptop Host Secrets

This host reads runtime secrets from:

- `$HOME/data/nix_secrets/laptop`

These secrets stay outside Git and outside the Nix store.

## 1) Create directory

```bash
mkdir -p $HOME/data/nix_secrets/laptop
chmod 700 $HOME/data/nix_secrets/laptop
```

## 2) Prefill from host template (optional)

```bash
cp -r ./hosts/laptop/secrets.template/* $HOME/data/nix_secrets/laptop/
chmod 600 $HOME/data/nix_secrets/laptop/*
```

## 3) Required host files

- `$HOME/data/nix_secrets/laptop/wifi-secrets.env`
  - `HOME_WIFI_SSID=...`
  - `HOME_WIFI_PSK=...`
- `$HOME/data/nix_secrets/laptop/smb-secrets.env`
  - `username=...`
  - `password=...`
- `$HOME/data/nix_secrets/laptop/gocryptfs-mm-secure-storage.pass`
  - one-line passphrase
- `$HOME/data/nix_secrets/laptop/restic.pass`
  - one-line passphrase

## 4) Apply

```bash
make rebuild-laptop
```

For user-level Git identity secrets, see `docs/guide-add-user.md`.
