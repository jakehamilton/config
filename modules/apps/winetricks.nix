{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.apps.winetricks;
in {
  options.plusultra.apps.winetricks = with types; {
    enable = mkBoolOpt false "Whether or not to enable Winetricks.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ winetricks ]; };
}
