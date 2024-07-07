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
  cfg = config.${namespace}.apps.winetricks;
in
{
  options.${namespace}.apps.winetricks = with types; {
    enable = mkBoolOpt false "Whether or not to enable Winetricks.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ winetricks ]; };
}
