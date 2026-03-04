{ config, ... }:
let
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
  xdg.configFile."mc/ini".source = pickConfig "mc/ini";
  xdg.dataFile."mc/skins/catppuccin.ini".source = pickConfig "mc/skins/catppuccin.ini";
}
