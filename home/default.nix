{inputs, ...}: {
  imports = [
    inputs.noctalia.homeModules.default

    ../modules/home/base.nix
    ../modules/home/shell.nix
    ../modules/home/git.nix
    ../modules/home/theme.nix
    ../modules/home/fonts.nix
    ../modules/home/firefox.nix
    ../modules/home/vscode.nix
    ../modules/home/devtools.nix
    ../modules/home/yazi.nix
    ../modules/home/mc.nix
    ../modules/home/neovim.nix
    ../modules/home/helix.nix
    ../modules/home/kitty.nix
    ../modules/home/desktop.nix
  ];
}
