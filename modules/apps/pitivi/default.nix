{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.apps.pitivi;
in {
  options.plusultra.apps.pitivi = with types; {
    enable = mkBoolOpt false "Whether or not to enable Pitivi.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ pitivi ]; };
}
