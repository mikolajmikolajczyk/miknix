{ pkgs, ... }:
{
  fonts = {
    packages = with pkgs; [
      inter
      pkgs.nerd-fonts.jetbrains-mono
      noto-fonts-color-emoji
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        sansSerif = [ "Inter" ];
        serif = [ "Inter" ];
        monospace = [ "JetBrainsMono Nerd Font" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
