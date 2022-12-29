{ options, config, lib, pkgs, ... }:
with lib;
let cfg = config.plusultra.archetypes.gaming;
in
{
  options.plusultra.archetypes.gaming = with types; {
    enable = mkBoolOpt false "Whether or not to enable the gaming archetype.";
  };

  config = mkIf cfg.enable {
    plusultra.suites = {
      common = enabled;
      desktop = enabled;
      games = enabled;
      social = enabled;
      media = enabled;
    };
  };
}
