{ config, lib, pkgs, ... }:

with lib;
with lib.plusultra;
let
  cfg = config.plusultra.tools.attic;
in
{
  options.plusultra.tools.attic = {
    enable = mkEnableOption "Attic";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      attic
    ];
  };
}
