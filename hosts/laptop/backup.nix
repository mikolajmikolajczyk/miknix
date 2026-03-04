{ config, ... }:
let
  homeDir = config.miknix.user.home;
in
{
  services.restic.backups = {
    critical = {
      repository = "/mnt/secure/backups/critical";
      passwordFile = "${config.miknix.secretsDir}/restic.pass";
      initialize = true;
      paths = [
        "${homeDir}/data"
        "${homeDir}/.gnupg"
        "${homeDir}/.pki"
        "${homeDir}/.config/noctalia"
      ];
      exclude = [
        "${homeDir}/.cache"
        "${homeDir}/Downloads"
        "${homeDir}/.local/share/Trash"
        "${homeDir}/from_backup"
        "${homeDir}/.config/kitty"
        "${homeDir}/.config/niri"
        "${homeDir}/.config/git"
      ];
      timerConfig = {
        OnCalendar = "09:00,17:00";
        Persistent = true;
      };
    };

    data = {
      repository = "/mnt/secure/backups/data";
      passwordFile = "${config.miknix.secretsDir}/restic.pass";
      initialize = true;
      paths = [
        "${homeDir}/src"
        "${homeDir}/cumulocity"
        "${homeDir}/.vscode"
        "${homeDir}/.config/Code"
        "${homeDir}/.config/Ferdium"
      ];
      exclude = [
        "${homeDir}/.cache"
        "${homeDir}/Downloads"
        "${homeDir}/.local/share/Trash"
        "${homeDir}/from_backup"
        "${homeDir}/.config/kitty"
        "${homeDir}/.config/niri"
        "${homeDir}/.config/git"
      ];
      timerConfig = {
        OnCalendar = "17:00";
        Persistent = true;
      };
    };
  };

  systemd.services."restic-backups-critical" = {
    requires = [ "mnt-secure.mount" ];
    after = [ "mnt-secure.mount" ];
  };

  systemd.services."restic-backups-data" = {
    requires = [ "mnt-secure.mount" ];
    after = [ "mnt-secure.mount" ];
  };
}
