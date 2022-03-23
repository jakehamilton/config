{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.apps.protontricks;
in {
  options.plusultra.apps.protontricks = with types; {
    enable = mkBoolOpt false "Whether or not to enable Protontricks.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ protontricks ];
  };
}
