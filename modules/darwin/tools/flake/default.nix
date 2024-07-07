{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.tools.flake;
in
{
  options.${namespace}.tools.flake = {
    enable = mkEnableOption "Flake";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ snowfallorg.flake ]; };
}
