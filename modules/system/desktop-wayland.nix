{
  inputs,
  pkgs,
  ...
}: {
  services.xserver.enable = true;

  services.displayManager.gdm.enable = true;
  services.displayManager.gdm.wayland = true;
  services.displayManager.defaultSession = "niri";

  security.pam.services.gdm.enableGnomeKeyring = true;
  security.pam.services.gdm-password.enableGnomeKeyring = true;
  security.pam.services.login.enableGnomeKeyring = true;

  services.xserver.xkb = {
    layout = "pl";
    variant = "";
  };

  imports = [
    inputs.niri.nixosModules.niri
  ];

  programs.niri.enable = true;
  programs.niri.package = pkgs.niri;

  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
  programs.xfconf.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  services.gnome.gnome-keyring.enable = true;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    config = {
      common = {
        default = ["gtk"];
      };
    };
  };

  environment.sessionVariables = {
    GTK_USE_PORTAL = "1";
  };

  environment.systemPackages = with pkgs; [
    seahorse
  ];

  xdg.mime.defaultApplications = {
    "inode/directory" = ["thunar.desktop"];
    "image/jpeg" = ["org.gnome.eog.desktop"];
    "image/png" = ["org.gnome.eog.desktop"];
    "image/gif" = ["org.gnome.eog.desktop"];
    "image/webp" = ["org.gnome.eog.desktop"];
    "image/bmp" = ["org.gnome.eog.desktop"];
    "image/tiff" = ["org.gnome.eog.desktop"];
    "image/x-portable-pixmap" = ["org.gnome.eog.desktop"];
    "image/x-portable-graymap" = ["org.gnome.eog.desktop"];
    "image/x-portable-bitmap" = ["org.gnome.eog.desktop"];
    "image/heif" = ["org.gnome.eog.desktop"];
    "image/heic" = ["org.gnome.eog.desktop"];
    "application/zip" = ["org.kde.ark.desktop"];
    "application/x-7z-compressed" = ["org.kde.ark.desktop"];
    "application/x-rar" = ["org.kde.ark.desktop"];
    "application/x-rar-compressed" = ["org.kde.ark.desktop"];
    "application/x-tar" = ["org.kde.ark.desktop"];
    "application/gzip" = ["org.kde.ark.desktop"];
    "application/x-bzip2" = ["org.kde.ark.desktop"];
    "application/x-xz" = ["org.kde.ark.desktop"];
    "application/x-zstd" = ["org.kde.ark.desktop"];
  };
}
