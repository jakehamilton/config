{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.ultra.apps.pitivi;
in {
  options.ultra.apps.pitivi = with types; {
    enable = mkBoolOpt true "Whether or not to enable Pitivi.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ pitivi ]; };
}
