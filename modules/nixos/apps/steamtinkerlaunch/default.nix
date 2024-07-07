{
  lib,
  pkgs,
  config,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.apps.steamtinkerlaunch;

  inherit (lib) mkIf mkEnableOption;
in
{
  options.${namespace}.apps.steamtinkerlaunch = {
    enable = mkEnableOption "Steam Tinker Launch";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ steamtinkerlaunch ]; };
}
