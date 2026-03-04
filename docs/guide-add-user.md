# Guide: Add or Change Primary User

This repo is prepared to avoid hardcoding the username in most places.
The main knobs are in `hosts/<host>/configuration.nix`:

```nix
miknix.user = {
  name = "mikolaj";
  description = "Mikolaj";
  group = "mikolaj";
};

miknix.secretsDir = "${config.miknix.user.home}/data/nix_secrets/laptop";
```

## 1) Change user on an existing host

1. Edit `hosts/laptop/configuration.nix` and update `miknix.user.*`.
2. Move secrets to the new home path if needed:
   - `$HOME/data/nix_secrets/laptop/*`
3. Rebuild:

```bash
sudo nixos-rebuild switch --flake .#laptop
```

## 2) Add a user-specific Home Manager profile

Home config entrypoint is `home/default.nix` and is wired by `modules/system/dev.nix`:

```nix
home-manager.users.${config.miknix.user.name} = import ../../home/default.nix;
```

If you want different user variants, create additional Home files, for example:
- `home/default.nix` (shared baseline)
- `home/work.nix` (work laptop)
- `home/private.nix` (private laptop)

Then select one in `modules/system/dev.nix` or per-host module import.

## 3) User Git secrets

Git identity can be user-local and separate from host secrets.

Create:

- `$HOME/data/nix_secrets/laptop/gitconfig`
- `$HOME/data/nix_secrets/laptop/git-work.inc`

Example `gitconfig`:

```ini
[user]
    name = YOUR NAME
    email = you@example.com

[includeIf "gitdir:/home/<user>/cumulocity/"]
    path = /home/<user>/.config/git/work.inc
```

Example `git-work.inc`:

```ini
[user]
    name = YOUR NAME
    email = your.work@email
```

Use strict permissions:

```bash
chmod 600 $HOME/data/nix_secrets/laptop/gitconfig $HOME/data/nix_secrets/laptop/git-work.inc
```

## 4) Important notes

- Keep bootstrap password out of git; set manually after install (`passwd <username>`).
- If user/group names change, ownership-sensitive paths may need a one-time `chown`.
- New files must be tracked by git (`git add ...`) or flakes may fail to evaluate.
