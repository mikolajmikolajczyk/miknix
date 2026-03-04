{ config, inputs, lib, pkgs, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  cfgRoot = ../../config;
  userCfg = cfgRoot + "/${config.home.username}";
  defaultCfg = cfgRoot + "/default";
  pickConfig = rel:
    let
      userPath = userCfg + "/${rel}";
      defaultPath = defaultCfg + "/${rel}";
    in
    if builtins.pathExists userPath then userPath else defaultPath;
in
{
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.catppuccin;
    colorScheme = "macchiato";
  };

  programs.niri.config = builtins.readFile (pickConfig "niri/config.kdl");

  programs.noctalia-shell = {
    enable = true;
    package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
    systemd.enable = true;
    settings = builtins.fromJSON (builtins.readFile (pickConfig "noctalia/settings.json"));
  };

  xdg.configFile."noctalia/colorschemes/CatppuccinMacchiato".source =
    pickConfig "noctalia/colorschemes/CatppuccinMacchiato";

  systemd.user.services.xwayland-satellite = {
    Unit = {
      Description = "Xwayland Satellite";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";
      Restart = "on-failure";
      RestartSec = 1;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  home.activation.installPywalfox = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if command -v pywalfox >/dev/null 2>&1; then
      pywalfox install >/dev/null 2>&1 || true
    fi
  '';

  home.packages = with pkgs; [
    kitty
    codex
    discord
    ferdium
    gimp
    eog
    adw-gtk3
    nwg-look
    qt6Packages.qt6ct
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qtwayland
    kdePackages.ark
    papirus-icon-theme
    pywal
    pywalfox-native
    spicetify-cli
    xwayland-satellite
    signal-desktop
    wl-clipboard
    copyq
    grim
    slurp
    playerctl
    pavucontrol
    restic-browser
  ];
}
