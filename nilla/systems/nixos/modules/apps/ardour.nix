{ lib, config, pkgs, ... }:
let
  cfg = config.plusultra.apps.ardour;
in
{
  options.plusultra.apps.ardour = {
    enable = lib.mkEnableOption "Ardour";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ ardour ];
  };
}
