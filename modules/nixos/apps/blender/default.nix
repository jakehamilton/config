{
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.apps.blender;
in
{
  options.${namespace}.apps.blender = with types; {
    enable = mkBoolOpt false "Whether or not to enable Blender.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ blender ]; };
}
