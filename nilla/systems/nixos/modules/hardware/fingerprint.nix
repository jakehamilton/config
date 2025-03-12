{ lib, config, ... }:
let
  cfg = config.plusultra.hardware.fingerprint;
in
{
  options.plusultra.hardware.fingerprint = {
    enable = lib.mkEnableOption "fingerprint reader support";
  };

  config = lib.mkIf cfg.enable { services.fprintd.enable = true; };
}
