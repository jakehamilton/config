{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.tools.icehouse;

  inherit (lib) mkEnableOption mkIf;
in
{
  options.${namespace}.tools.icehouse = {
    enable = mkEnableOption "Icehouse";
  };

  config = mkIf cfg.enable { environment.systemPackages = [ pkgs.snowfallorg.icehouse ]; };
}
