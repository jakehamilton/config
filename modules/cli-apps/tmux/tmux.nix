{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.plusultra.cli-apps.tmux;
  configFiles = getFilesRec ./config;
in
{
  options.plusultra.cli-apps.tmux = with types; {
    enable = mkBoolOpt false "Whether or not to enable tmux.";
  };

  config = mkIf cfg.enable {
    plusultra.home.extraOptions = {
      programs.tmux = {
        enable = true;
        terminal = "screen-256color-bce";
        clock24 = true;
        historyLimit = 2000;
        keyMode = "vi";
        newSession = true;
        extraConfig = builtins.concatStringsSep "\n"
          (builtins.map lib.strings.fileContents configFiles);
        plugins = with pkgs.tmuxPlugins; [
          continuum
          nord
          tilish
          tmux-fzf
          vim-tmux-navigator
        ];
      };
    };
  };
}
