{ config, inputs, lib, pkgs, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  cfgRoot = ../../config;
  userCfg = cfgRoot + "/${config.home.username}";
  defaultCfg = cfgRoot + "/default";
  togglePowerProfile = pkgs.writeShellScriptBin "toggle-power-profile" ''
    current="$(${pkgs.power-profiles-daemon}/bin/powerprofilesctl get 2>/dev/null || true)"

    case "$current" in
      power-saver) next="balanced" ;;
      balanced) next="performance" ;;
      performance) next="power-saver" ;;
      *) next="balanced" ;;
    esac

    ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set "$next"

    if command -v notify-send >/dev/null 2>&1; then
      notify-send "Power profile" "Switched to $next"
    fi
  '';
  thunarOpenTerminalHere = pkgs.writeShellScriptBin "thunar-open-terminal-here" ''
    target="$1"
    [ -n "$target" ] || target="$PWD"

    if [ -d "$target" ]; then
      dir="$target"
    else
      dir="$(dirname "$target")"
    fi

    exec kitty --working-directory "$dir"
  '';
  thunarCopyPath = pkgs.writeShellScriptBin "thunar-copy-path" ''
    target="$1"
    [ -n "$target" ] || exit 1

    abs="$(${pkgs.coreutils}/bin/realpath "$target")"
    printf '%s' "$abs" | wl-copy
    notify-send "Path copied" "$abs"
  '';
  thunarChecksum = pkgs.writeShellScriptBin "thunar-checksum" ''
    target="$1"
    [ -n "$target" ] || exit 1

    if [ -d "$target" ]; then
      exec kitty --working-directory "$target"
    fi

    dir="$(dirname "$target")"
    base="$(basename "$target")"

    exec kitty --working-directory "$dir" sh -lc '
      echo "SHA-256:";
      sha256sum "$1";
      echo;
      echo "BLAKE2:";
      b2sum "$1";
      echo;
      read -r -p "Press Enter to close..." _
    ' sh "$base"
  '';
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
  xdg.configFile."Thunar/uca.xml".source = pickConfig "thunar/uca.xml";

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
    element-desktop
    wl-clipboard
    copyq
    togglePowerProfile
    thunarOpenTerminalHere
    thunarCopyPath
    thunarChecksum
    grim
    slurp
    playerctl
    pavucontrol
    libnotify
    restic-browser
  ];
}
