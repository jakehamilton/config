{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.apps.lutris;
in {
  options.plusultra.apps.lutris = with types; {
    enable = mkBoolOpt false "Whether or not to enable Lutris.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ lutris ]; };
}
