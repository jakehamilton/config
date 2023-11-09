{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.plusultra; let
  cfg = config.plusultra.cli-apps.thaw;
in {
  options.plusultra.cli-apps.thaw = with types; {
    enable = mkBoolOpt false "Whether or not to enable thaw.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      snowfallorg.thaw
    ];
  };
}
