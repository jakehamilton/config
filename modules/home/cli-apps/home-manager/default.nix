{ lib, config, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.internal) enabled;

  cfg = config.plusultra.cli-apps.home-manager;
in
{
  options.plusultra.cli-apps.home-manager = {
    enable = mkEnableOption "home-manager";
  };

  config = mkIf cfg.enable {
    programs.home-manager = enabled;
  };
}
