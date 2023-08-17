{ options, config, lib, pkgs, ... }:

with lib;
with lib.plusultra;
let
  cfg = config.plusultra.apps.gimp;
in
{
  options.plusultra.apps.gimp = with types; {
    enable = mkBoolOpt false "Whether or not to enable Gimp.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ gimp ]; };
}
