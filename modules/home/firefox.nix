{ pkgs, ... }:
let
  firefoxPersonal = pkgs.writeShellScriptBin "firefox-personal" ''
    set -eu
    export MOZ_GTK_TITLEBAR_DECORATION=client
    exec ${pkgs.firefox}/bin/firefox --no-remote -P "personal" "$@"
  '';
  firefoxWork = pkgs.writeShellScriptBin "firefox-work" ''
    set -eu
    export MOZ_GTK_TITLEBAR_DECORATION=client
    exec ${pkgs.firefox}/bin/firefox --no-remote -P "work" "$@"
  '';
in
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    policies = {
      Preferences = {
        "widget.use-xdg-desktop-portal.file-picker" = 1;
      };
      ExtensionSettings = let
        moz = short: "https://addons.mozilla.org/firefox/downloads/latest/${short}/latest.xpi";
      in {
        "*".installation_mode = "blocked";
        "clipper@obsidian.md" = {
          install_url = moz "web-clipper-obsidian";
          installation_mode = "force_installed";
          updates_disabled = false;
        };
        "pass@proton.me" = {
          install_url = moz "proton-pass";
          installation_mode = "force_installed";
          updates_disabled = false;
        };
        "vpn@proton.ch" = {
          install_url = moz "proton-vpn";
          installation_mode = "force_installed";
          updates_disabled = false;
        };
        "pywalfox@frewacom.org" = {
          install_url = moz "pywalfox";
          installation_mode = "force_installed";
          updates_disabled = false;
        };
      };
    };
    profilesPath = "data/firefox";
    profiles = {
      personal = {
        id = 0;
        name = "personal";
        path = "personal";
        extensions.force = true;
      };
      work = {
        id = 1;
        name = "work";
        path = "work";
        extensions.force = true;
      };
    };
  };
  home.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
  };
  xdg.desktopEntries = {
    firefox-personal = {
      name = "Firefox Personal";
      genericName = "Web Browser";
      exec = "firefox-personal %u";
      terminal = false;
      categories = [ "Network" "WebBrowser" ];
      icon = "firefox";
      mimeType = [
        "text/html"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
      ];
    };
    firefox-work = {
      name = "Firefox Work";
      genericName = "Web Browser";
      exec = "firefox-work %u";
      terminal = false;
      categories = [ "Network" "WebBrowser" ];
      icon = "firefox";
      mimeType = [
        "text/html"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
      ];
    };
  };

  home.packages = [
    firefoxPersonal
    firefoxWork
  ];
}
