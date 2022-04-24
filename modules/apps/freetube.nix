{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.apps.freetube;
in {
  options.plusultra.apps.freetube = with types; {
    enable = mkBoolOpt false "Whether or not to enable FreeTube.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ freetube ]; };
}
