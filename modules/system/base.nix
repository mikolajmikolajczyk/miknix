{ config, pkgs, ... }:
let
  user = config.miknix.user;
in
{
  time.timeZone = "Europe/Warsaw";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "pl_PL.UTF-8";
      LC_IDENTIFICATION = "pl_PL.UTF-8";
      LC_MEASUREMENT = "pl_PL.UTF-8";
      LC_MONETARY = "pl_PL.UTF-8";
      LC_NAME = "pl_PL.UTF-8";
      LC_NUMERIC = "pl_PL.UTF-8";
      LC_PAPER = "pl_PL.UTF-8";
      LC_TELEPHONE = "pl_PL.UTF-8";
      LC_TIME = "pl_PL.UTF-8";
    };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "spotify"
    ];

  users.users.${user.name} = {
    isNormalUser = true;
    description = user.description;
    home = user.home;
    group = user.group;
    extraGroups = [ "wheel" "networkmanager" "docker" "kvm" "libvirtd" "video" "audio" "input" "render" ];
    shell = pkgs.zsh;
  };
  users.groups.${user.group} = { };
  users.defaultUserShell = pkgs.zsh;

  security.sudo.wheelNeedsPassword = true;
  programs.zsh.enable = true;
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  services.openssh.enable = true;
  hardware.bluetooth.enable = true;
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
  zramSwap = {
    enable = true;
    memoryPercent = 50;
    algorithm = "zstd";
  };
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };
  virtualisation.libvirtd = {
    enable = true;
    qemu.package = pkgs.qemu_kvm;
  };
  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    jq
    yq
    libsecret
    neovim
    codex
    pulseaudio
    restic
    ripgrep
    gocryptfs
    power-profiles-daemon
    samba
    nfs-utils
    qemu_kvm
    cryptsetup
    btop
    gptfdisk
    parted
    unzip
    zip
    p7zip
    unrar
    xz
    zstd
    gzip
    bzip2
    lz4
    btrfs-progs
  ];
}
