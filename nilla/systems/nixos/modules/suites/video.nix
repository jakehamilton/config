{ lib, config, ... }:
let
  cfg = config.plusultra.suites.video;
in
{
  options.plusultra.suites.video = {
    enable = lib.mkEnableOption "the video suite";
  };

  config = lib.mkIf cfg.enable {
    plusultra = {
      apps = {
        obs.enable = true;
      };
    };
  };
}
