{pkgs, ...}: let
  vscodeExt = pkgs.vscode-extensions;
in {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    profiles.default.extensions = with vscodeExt; [
      eamodio.gitlens
      jnoortheen.nix-ide
      github.vscode-github-actions
      ms-vscode.makefile-tools
      ms-azuretools.vscode-docker
      ms-vscode-remote.remote-containers
      catppuccin.catppuccin-vsc
      anthropic.claude-code
    ];
    profiles.default.userSettings = {
      "editor.fontFamily" = "JetBrainsMono Nerd Font";
      "editor.fontLigatures" = true;
      "terminal.integrated.fontFamily" = "JetBrainsMono Nerd Font";
      "workbench.fontFamily" = "Inter";
      "workbench.colorTheme" = "Catppuccin Macchiato";
      "catppuccin.accentColor" = "mauve";
      "catppuccin.italicComments" = true;
      "catppuccin.italicKeywords" = true;
      "catppuccin.boldKeywords" = true;
      "catppuccin.workbenchMode" = "default";
      "catppuccin.bracketMode" = "rainbow";
      "catppuccin.extraBordersEnabled" = false;
    };
  };
}
