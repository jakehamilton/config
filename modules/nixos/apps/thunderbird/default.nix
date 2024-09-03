{ config, pkgs, lib, ... }:
let
  cfg = config.plusultra.apps.thunderbird;
in
{
  options.plusultra.apps.thunderbird = {
    enable = lib.mkEnableOption "Thunderbird";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.thunderbird;
      description = "Thunderbird package to use";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
