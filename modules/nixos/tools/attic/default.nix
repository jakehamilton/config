{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.tools.attic;
in
{
  options.${namespace}.tools.attic = {
    enable = mkEnableOption "Attic";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ attic ]; };
}
