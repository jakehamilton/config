{ lib, config, ... }:
let
  cfg = config.plusultra.archetypes.workstation;
in
{
  options.plusultra.archetypes.workstation = {
    enable = lib.mkEnableOption "the workstation archetype";
  };

  config = lib.mkIf cfg.enable {
    plusultra = {
      suites = {
        common.enable = true;
        desktop.enable = true;
        development.enable = true;
        art.enable = true;
        video.enable = true;
        social.enable = true;
        media.enable = true;
      };

      tools = {
        appimage-run.enable = true;
      };
    };
  };
}
