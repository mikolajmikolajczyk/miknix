{ config, pkgs, ... }:
let
  secretsDir = config.miknix.secretsDir;
  user = config.miknix.user;
in
{
  environment.systemPackages = with pkgs; [
    cifs-utils
  ];

  fileSystems."/mnt/old_home" = {
    device = "//192.168.50.201/home";
    fsType = "cifs";
    options = [
      "credentials=${secretsDir}/smb-secrets.env"
      "x-systemd.automount"
      "x-systemd.idle-timeout=300"
      "noauto"
      "vers=3.0"
      "uid=1000"
      "gid=100"
      "file_mode=0640"
      "dir_mode=0750"
      "x-systemd.requires=network-online.target"
      "x-systemd.after=network-online.target"
    ];
  };

  fileSystems."/mnt/mm_secure_storage" = {
    device = "//192.168.50.201/mikolaj_secure_storage";
    fsType = "cifs";
    options = [
      "credentials=${secretsDir}/smb-secrets.env"
      "x-systemd.automount"
      "x-systemd.idle-timeout=300"
      "noauto"
      "vers=3.0"
      "uid=1000"
      "gid=989"
      "file_mode=0600"
      "dir_mode=0700"
      "noperm"
      "x-systemd.requires=network-online.target"
      "x-systemd.after=network-online.target"
    ];
  };

  systemd.tmpfiles.rules = [
    "d /mnt/secure 0700 ${user.name} ${user.group} - -"
  ];

  systemd.automounts = [
    {
      where = "/mnt/secure";
      wantedBy = [ "multi-user.target" ];
    }
  ];

  systemd.mounts = [
    {
      what = "/mnt/mm_secure_storage/.crypt";
      where = "/mnt/secure";
      type = "fuse.gocryptfs";
      options = "passfile=${secretsDir}/gocryptfs-mm-secure-storage.pass,allow_other";
      after = [ "mnt-mm_secure_storage.mount" "network-online.target" ];
      wants = [ "network-online.target" ];
      requires = [ "mnt-mm_secure_storage.mount" ];
    }
  ];
}
