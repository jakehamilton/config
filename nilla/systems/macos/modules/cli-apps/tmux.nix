{
  lib,
  config,
  pkgs,
  project,
  ...
}:
let
  cfg = config.plusultra.cli-apps.tmux;
in
{
  options.plusultra.cli-apps.tmux = {
    enable = lib.mkEnableOption "tmux";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      project.packages.tmux.result.${pkgs.stdenv.hostPlatform.system}
    ];
  };
}
