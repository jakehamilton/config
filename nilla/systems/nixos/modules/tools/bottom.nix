{ lib, config, pkgs, ... }:
let
  cfg = config.plusultra.tools.bottom;
in
{
  options.plusultra.tools.bottom = {
    enable = lib.mkEnableOption "Bottom";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ bottom ];
  };
}
