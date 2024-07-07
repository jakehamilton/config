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
  cfg = config.${namespace}.apps.ardour;
in
{
  options.${namespace}.apps.ardour = with types; {
    enable = mkBoolOpt false "Whether or not to enable Ardour.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ ardour ]; };
}
