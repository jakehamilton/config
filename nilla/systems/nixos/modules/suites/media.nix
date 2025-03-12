{ lib, config, ... }:
let
  cfg = config.plusultra.suites.media;
in
{
  options.plusultra.suites.media = {
    enable = lib.mkEnableOption "the media suite";
  };

  config = lib.mkIf cfg.enable {
    plusultra = {
      apps = {
      };
    };
  };
}
