{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.plusultra.cli-apps.proton;
in
{
  options.plusultra.cli-apps.proton = with types; {
    enable = mkBoolOpt false "Whether or not to enable Proton.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ proton-caller ];
  };
}
