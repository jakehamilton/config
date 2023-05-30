{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.plusultra.apps.hey;
in
{
  options.plusultra.apps.hey = with types; {
    enable = mkBoolOpt false "Whether or not to enable HEY.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs.plusultra; [ hey ]; };
}
