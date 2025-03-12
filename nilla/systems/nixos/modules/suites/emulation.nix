{ lib, config, ... }:
let
  cfg = config.plusultra.suites.emulation;
in
{
  options.plusultra.suites.emulation = {
    enable = lib.mkEnableOption "the emulation suite";
  };

  config = lib.mkIf cfg.enable {
    plusultra = {
      apps = {
        dolphin.enable = true;
      };
    };
  };
}
