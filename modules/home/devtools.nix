{ config, lib, pkgs, ... }:
let
  cfgRoot = ../../config;
  userCfg = cfgRoot + "/${config.home.username}";
  defaultCfg = cfgRoot + "/default";
  noctaliaColors =
    let
      userPath = userCfg + "/noctalia/colorschemes/CatppuccinMacchiato/CatppuccinMacchiato.json";
      defaultPath = defaultCfg + "/noctalia/colorschemes/CatppuccinMacchiato/CatppuccinMacchiato.json";
    in
    if builtins.pathExists userPath then userPath else defaultPath;
in
{

  home.packages = with pkgs; [
    gcc
    gnumake
    pkg-config
    go
    nixfmt
    python3
    mc
    yazi
    ueberzugpp

    docker-client
    podman
    podman-compose
    dive
    kubectl
    openshift
    kubelogin
    awscli2
    azure-cli
    aws-iam-authenticator
    k9s
  ];

  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "nixos";
        padding.right = 2;
      };
      display = {
        color = "blue";
        separator = " -> ";
      };
      modules = [
        "title"
        "break"
        {
          type = "os";
          key = "OS";
        }
        {
          type = "kernel";
          key = "Kernel";
        }
        {
          type = "uptime";
          key = "Uptime";
        }
        {
          type = "packages";
          key = "Pkgs";
        }
        {
          type = "shell";
          key = "Shell";
        }
        {
          type = "wm";
          key = "WM";
        }
        {
          type = "terminal";
          key = "Term";
        }
        {
          type = "cpu";
          key = "CPU";
        }
        {
          type = "memory";
          key = "Memory";
        }
        {
          type = "battery";
          key = "Battery";
        }
        {
          type = "disk";
          key = "Disk";
        }
      ];
    };
  };

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "noctalia";
    };
  };

  home.sessionVariables = {
    K9S_SKIN = "noctalia";
  };

  home.activation.k9sPywalSkin = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    noctalia_colors="${noctaliaColors}"
    skin_dir="${config.xdg.configHome}/k9s/skins"
    skin_file="$skin_dir/noctalia.yaml"

    if [ -f "$noctalia_colors" ]; then
      mkdir -p "$skin_dir"
      ${pkgs.jq}/bin/jq -r '
        def t($k): .dark.terminal[$k];
        def n($k): t("normal")[$k];
        def b($k): t("bright")[$k];
        "k9s:\n" +
        "  body:\n" +
        "    fgColor: \"" + t("foreground") + "\"\n" +
        "    bgColor: \"" + t("background") + "\"\n" +
        "    logoColor: \"" + n("blue") + "\"\n" +
        "  prompt:\n" +
        "    fgColor: \"" + t("foreground") + "\"\n" +
        "    bgColor: \"" + t("background") + "\"\n" +
        "    suggestionColor: \"" + n("blue") + "\"\n" +
        "  info:\n" +
        "    fgColor: \"" + n("blue") + "\"\n" +
        "    sectionColor: \"" + n("cyan") + "\"\n" +
        "  dialog:\n" +
        "    fgColor: \"" + t("foreground") + "\"\n" +
        "    bgColor: \"" + t("background") + "\"\n" +
        "    buttonFgColor: \"" + t("background") + "\"\n" +
        "    buttonBgColor: \"" + n("blue") + "\"\n" +
        "    buttonFocusFgColor: \"" + t("background") + "\"\n" +
        "    buttonFocusBgColor: \"" + n("cyan") + "\"\n" +
        "  frame:\n" +
        "    border:\n" +
        "      fgColor: \"" + b("black") + "\"\n" +
        "      focusColor: \"" + n("blue") + "\"\n" +
        "    menu:\n" +
        "      fgColor: \"" + t("foreground") + "\"\n" +
        "      keyColor: \"" + n("magenta") + "\"\n" +
        "      numKeyColor: \"" + n("magenta") + "\"\n" +
        "    crumbs:\n" +
        "      fgColor: \"" + t("background") + "\"\n" +
        "      bgColor: \"" + n("blue") + "\"\n" +
        "      activeColor: \"" + n("cyan") + "\"\n" +
        "    status:\n" +
        "      newColor: \"" + n("green") + "\"\n" +
        "      modifyColor: \"" + n("yellow") + "\"\n" +
        "      addColor: \"" + n("green") + "\"\n" +
        "      errorColor: \"" + n("red") + "\"\n" +
        "      highlightColor: \"" + n("blue") + "\"\n" +
        "      killColor: \"" + n("red") + "\"\n" +
        "      completedColor: \"" + n("green") + "\"\n" +
        "    title:\n" +
        "      fgColor: \"" + t("foreground") + "\"\n" +
        "      bgColor: \"" + t("background") + "\"\n" +
        "      highlightColor: \"" + n("blue") + "\"\n"
      ' "$noctalia_colors" > "$skin_file"
    fi
  '';
}
