{ lib, config, ... }:
let
  cfg = config.plusultra.services.printing;
in
{
  options.plusultra.services.printing = {
    enable = lib.mkEnableOption "printing support";
  };

  config = lib.mkIf cfg.enable {
    services.printing.enable = true;
  };
}
