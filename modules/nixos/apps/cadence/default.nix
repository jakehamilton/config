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
  cfg = config.${namespace}.apps.cadence;
in
{
  options.${namespace}.apps.cadence = with types; {
    enable = mkBoolOpt false "Whether or not to enable Cadence.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ cadence ]; };
}
