{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.apps.polymc;
in {
  options.plusultra.apps.polymc = with types; {
    enable = mkBoolOpt false "Whether or not to enable PolyMC.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ polymc ]; };
}
