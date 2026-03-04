{ pkgs, ... }:
let
  vscodeExt = pkgs.vscode-extensions;
  openaiChatgpt = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "openai";
      name = "chatgpt";
      version = "0.4.79";
      sha256 = "0rhr5d0c5s7q4f01q4s9dr838fbr32vcphg50xl9g70238d795m8";
    };
  };
in
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    profiles.default.extensions =
      (with vscodeExt; [
        eamodio.gitlens
        jnoortheen.nix-ide
        github.vscode-github-actions
        ms-vscode.makefile-tools
        ms-azuretools.vscode-docker
        ms-vscode-remote.remote-containers
        catppuccin.catppuccin-vsc
      ])
      ++ [ openaiChatgpt ];
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
