{ config, inputs, ... }:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit inputs; };
  home-manager.backupFileExtension = "hm-bak";
  home-manager.users.${config.miknix.user.name} = import ../../home/default.nix;
}
