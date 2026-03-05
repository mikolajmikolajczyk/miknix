{
  config,
  lib,
  ...
}: {
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
  xdg.enable = true;

  home.file = {
    ".ssh".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/data/ssh";
    ".aws".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/data/aws";
    "Dokumenty".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/data/Dokumenty";
  };
}
