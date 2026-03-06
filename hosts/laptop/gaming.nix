{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  programs.gamemode.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  programs.steam.extraCompatPackages = [pkgs.proton-ge-bin];

  environment.systemPackages = with pkgs; [
    mesa
    vulkan-tools
    lutris
    protonup-qt
    winetricks
    wineWow64Packages.stable
    mangohud
  ];
}
