{ lib, config, ... }:
let
  cfg = config.plusultra.archetypes.gaming;
in
{
  options.plusultra.archetypes.gaming = {
    enable = lib.mkEnableOption "the gaming archetype";
  };

  config = lib.mkIf cfg.enable {
    plusultra = {
      suites = {
        common.enable = true;
        desktop.enable = true;
        games.enable = true;
        social.enable = true;
        media.enable = true;
      };
    };
  };
}
