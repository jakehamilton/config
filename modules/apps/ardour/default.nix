{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.apps.ardour;
in {
  options.plusultra.apps.ardour = with types; {
    enable = mkBoolOpt false "Whether or not to enable Ardour.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ ardour ]; };
}
