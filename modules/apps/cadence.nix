{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.apps.cadence;
in {
  options.plusultra.apps.cadence = with types; {
    enable = mkBoolOpt false "Whether or not to enable Cadence.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ cadence ]; };
}
