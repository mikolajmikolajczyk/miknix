{
  config,
  osConfig,
  ...
}: let
  secretsDir = osConfig.miknix.secretsDir;
in {
  programs.git = {
    enable = true;
    settings = {
      commit.gpgsign = true;
      tag.gpgSign = true;
      gpg.program = "gpg";
      user.signingKey = "B51B3C73D7D03D27!";
      include.path = "${config.xdg.configHome}/git/secret.inc";
    };
  };

  home.file."${config.xdg.configHome}/git/secret.inc".source =
    config.lib.file.mkOutOfStoreSymlink "${secretsDir}/gitconfig";
  home.file."${config.xdg.configHome}/git/work.inc".source =
    config.lib.file.mkOutOfStoreSymlink "${secretsDir}/git-work.inc";
}
