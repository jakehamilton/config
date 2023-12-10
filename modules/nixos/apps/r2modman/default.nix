{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.plusultra; let
  cfg = config.plusultra.apps.r2modman;
in {
  options.plusultra.apps.r2modman = with types; {
    enable = mkBoolOpt false "Whether or not to enable r2modman.";
  };

  config =
    mkIf cfg.enable {environment.systemPackages = with pkgs; [r2modman];};
}
