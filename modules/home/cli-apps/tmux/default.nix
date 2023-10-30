{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.plusultra; let
  cfg = config.plusultra.cli-apps.tmux;
in {
  options.plusultra.cli-apps.tmux = {
    enable = mkEnableOption "Tmux";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      plusultra.tmux
    ];
  };
}
