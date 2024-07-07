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
  cfg = config.${namespace}.apps.freetube;
in
{
  options.${namespace}.apps.freetube = with types; {
    enable = mkBoolOpt false "Whether or not to enable FreeTube.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ freetube ]; };
}
