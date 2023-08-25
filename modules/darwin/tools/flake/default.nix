{ lib, config, pkgs, ... }:

with lib;
with lib.plusultra;
let
  cfg = config.plusultra.tools.flake;
in
{
  options.plusultra.tools.flake = {
    enable = mkEnableOption "Flake";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      snowfallorg.flake
    ];
  };
}
