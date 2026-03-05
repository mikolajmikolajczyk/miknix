{pkgs, ...}: {
  services.pcscd.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    enableExtraSocket = true;
  };

  boot.initrd.systemd.enable = true;
  boot.initrd.systemd.fido2.enable = true;

  environment.systemPackages = with pkgs; [
    yubikey-manager
    yubikey-personalization
    libfido2
  ];
}
