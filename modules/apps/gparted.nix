{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.apps.gparted;
in {
  options.plusultra.apps.gparted = with types; {
    enable = mkBoolOpt false "Whether or not to enable gparted.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ gparted ]; };
}
