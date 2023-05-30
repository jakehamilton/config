{ config, lib, pkgs, ... }:

let
  cfg = config.plusultra.tools.icehouse;

  inherit (lib) mkEnableOption mkIf;
in
{
  options.plusultra.tools.icehouse = {
    enable = mkEnableOption "Icehouse";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.snowfallorg.icehouse ];
  };
}
