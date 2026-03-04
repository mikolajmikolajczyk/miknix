{ config, ... }:
let
  wifiSecretsFile = "${config.miknix.secretsDir}/wifi-secrets.env";
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/secrets.nix
    ../../modules/system/base.nix
    ../../modules/system/networking.nix
    ../../modules/system/audio.nix
    ../../modules/system/fonts.nix
    ../../modules/system/desktop-wayland.nix
    ../../modules/system/yubikey.nix
    ../../modules/system/dev.nix
    ./gaming.nix
    ./storage.nix
    ./backup.nix
    ./nvidia.nix
    (import ./wifi-profiles.nix { inherit wifiSecretsFile; })
  ];

  miknix.user = {
    name = "mikolaj";
    description = "Mikolaj";
    group = "mikolaj";
  };

  miknix.secretsDir = "${config.miknix.user.home}/data/nix_secrets/laptop";

  # Firmware blobs needed for Wi-Fi/GPU/audio on this laptop class.
  hardware.enableRedistributableFirmware = true;

  # Explicitly load commonly required modules for detected NIC/audio hardware.
  boot.kernelModules = [
    "mt7921e"
    "r8169"
    "snd_hda_intel"
    "snd_pci_ps"
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "uas"
    "usb_storage"
    "sd_mod"
    "sr_mod"
    "vmd"
    "nvme"
  ];

  # Bootstrap password is intentionally not stored in this repo.
  # After install set it manually:
  #   nixos-enter --root /mnt
  #   passwd <username>

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices.cryptroot.crypttabExtraOpts = [ "fido2-device=auto" ];

  powerManagement.enable = true;
  services.power-profiles-daemon.enable = true;
  services.fwupd.enable = true;
}
