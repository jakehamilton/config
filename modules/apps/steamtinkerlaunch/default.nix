{ lib, pkgs, config, ... }:

let
  cfg = config.plusultra.apps.steamtinkerlaunch;

  inherit (lib) mkIf mkEnableOption;
in
{
  options.plusultra.apps.steamtinkerlaunch = {
    enable = mkEnableOption "Steam Tinker Launch";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      steamtinkerlaunch
    ];
  };
}
