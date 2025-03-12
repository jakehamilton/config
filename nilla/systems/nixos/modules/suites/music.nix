{ lib, config, ... }:
let
  cfg = config.plusultra.suites.music;
in
{
  options.plusultra.suites.music = {
    enable = lib.mkEnableOption "the music suite";
  };

  config = lib.mkIf cfg.enable {
    plusultra = {
      apps = {
        ardour.enable = true;
        bottles.enable = true;
      };
    };
  };
}
