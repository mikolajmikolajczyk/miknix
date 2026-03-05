{config, ...}: let
  cfgRoot = ../../config;
  userCfg = cfgRoot + "/${config.home.username}";
  defaultCfg = cfgRoot + "/default";
  yaziConfig = let
    userPath = userCfg + "/yazi/yazi.toml";
    defaultPath = defaultCfg + "/yazi/yazi.toml";
  in
    if builtins.pathExists userPath
    then userPath
    else defaultPath;
in {
  xdg.configFile."yazi/yazi.toml".source = yaziConfig;
}
