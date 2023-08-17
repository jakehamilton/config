{ options, config, pkgs, lib, ... }:

with lib;
with lib.plusultra;
let cfg = config.plusultra.services.printing;
in
{
  options.plusultra.services.printing = with types; {
    enable = mkBoolOpt false "Whether or not to configure printing support.";
  };

  config = mkIf cfg.enable { services.printing.enable = true; };
}
