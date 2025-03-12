{ lib
, config
, pkgs
, ...
}:
let
  cfg = config.plusultra.apps.blender;
in
{
  options.plusultra.apps.blender = {
    enable = lib.mkEnableOption "Blender";
  };

  config = lib.mkIf cfg.enable { environment.systemPackages = with pkgs; [ blender ]; };
}
