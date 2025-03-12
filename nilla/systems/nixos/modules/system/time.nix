{ lib, config, ... }:
let
  cfg = config.plusultra.system.time;
in
{
  options.plusultra.system.time = {
    enable = lib.mkEnableOption "time configuration";
  };

  config = lib.mkIf cfg.enable {
    time.timeZone = "America/Los_Angeles";
  };
}
