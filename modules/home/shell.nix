{
  config,
  lib,
  ...
}: {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    dotDir = "${config.xdg.configHome}/zsh";
    history = {
      path = "${config.xdg.dataHome}/zsh/history";
      size = 100000;
      save = 100000;
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      extended = true;
      expireDuplicatesFirst = true;
      share = true;
    };
    initContent = lib.mkBefore ''
      # Better, less surprising history behavior.
      setopt HIST_FCNTL_LOCK
      setopt HIST_IGNORE_DUPS
      setopt HIST_IGNORE_ALL_DUPS
      setopt HIST_IGNORE_SPACE
      setopt HIST_REDUCE_BLANKS
      setopt HIST_VERIFY
      setopt APPEND_HISTORY
      setopt INC_APPEND_HISTORY
      setopt SHARE_HISTORY

      # Quick file manager shortcut.
      alias t="thunar ."

      # Show system summary on interactive shell start.
      if command -v fastfetch >/dev/null 2>&1; then
        fastfetch
      fi
    '';
  };
}
