{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.apps.hey;
in
{
  options.plusultra.apps.hey = with types; {
    enable = mkBoolOpt false "Whether or not to enable HEY.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs.plusultra; [ hey ]; };
}
