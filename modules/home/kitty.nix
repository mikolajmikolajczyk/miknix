{
  config,
  lib,
  pkgs,
  ...
}: let
  cfgRoot = ../../config;
  userCfg = cfgRoot + "/${config.home.username}";
  defaultCfg = cfgRoot + "/default";
  noctaliaColors = let
    userPath = userCfg + "/noctalia/colorschemes/CatppuccinMacchiato/CatppuccinMacchiato.json";
    defaultPath = defaultCfg + "/noctalia/colorschemes/CatppuccinMacchiato/CatppuccinMacchiato.json";
  in
    if builtins.pathExists userPath
    then userPath
    else defaultPath;
in {
  programs.kitty = {
    enable = true;
    extraConfig = ''
      include noctalia.conf
    '';
  };

  home.activation.syncKittyNoctalia = lib.hm.dag.entryAfter ["writeBoundary"] ''
    kitty_dir="${config.xdg.configHome}/kitty"
    mkdir -p "$kitty_dir"
    ${pkgs.jq}/bin/jq -r '
      .dark.terminal as $t |
      "foreground \($t.foreground)\n" +
      "background \($t.background)\n" +
      "cursor \($t.cursor)\n" +
      "cursor_text_color \($t.cursorText)\n" +
      "selection_foreground \($t.selectionForeground)\n" +
      "selection_background \($t.selectionBackground)\n" +
      "color0  \($t.normal.black)\n" +
      "color1  \($t.normal.red)\n" +
      "color2  \($t.normal.green)\n" +
      "color3  \($t.normal.yellow)\n" +
      "color4  \($t.normal.blue)\n" +
      "color5  \($t.normal.magenta)\n" +
      "color6  \($t.normal.cyan)\n" +
      "color7  \($t.normal.white)\n" +
      "color8  \($t.bright.black)\n" +
      "color9  \($t.bright.red)\n" +
      "color10 \($t.bright.green)\n" +
      "color11 \($t.bright.yellow)\n" +
      "color12 \($t.bright.blue)\n" +
      "color13 \($t.bright.magenta)\n" +
      "color14 \($t.bright.cyan)\n" +
      "color15 \($t.bright.white)\n"
    ' ${noctaliaColors} \
      > "$kitty_dir/noctalia.conf"
  '';
}
