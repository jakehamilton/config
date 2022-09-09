{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.apps.blender;
in {
  options.plusultra.apps.blender = with types; {
    enable = mkBoolOpt false "Whether or not to enable Blender.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ blender ]; };
}
