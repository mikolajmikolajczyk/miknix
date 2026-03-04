{ lib, config, ... }:
{
  options.miknix = {
    user = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "mikolaj";
        description = "Primary local username for this host.";
      };

      description = lib.mkOption {
        type = lib.types.str;
        default = "Mikolaj";
        description = "Display name for the primary local user.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = config.miknix.user.name;
        description = "Primary group name for the user.";
      };

      home = lib.mkOption {
        type = lib.types.str;
        default = "/home/${config.miknix.user.name}";
        description = "Home directory path for the primary user.";
      };
    };

    secretsDir = lib.mkOption {
      type = lib.types.str;
      default = "${config.miknix.user.home}/data/nix_secrets/laptop";
      description = "Absolute path to host-local secret files.";
    };
  };
}
