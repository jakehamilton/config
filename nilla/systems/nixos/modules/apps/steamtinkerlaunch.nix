{ lib
, config
, pkgs
, ...
}:
let
  cfg = config.plusultra.apps.steamtinkerlaunch;
in
{
  options.plusultra.apps.steamtinkerlaunch = {
    enable = lib.mkEnableOption "Steam Tinker Launch";
  };

  config = lib.mkIf cfg.enable { environment.systemPackages = with pkgs; [ steamtinkerlaunch ]; };
}
