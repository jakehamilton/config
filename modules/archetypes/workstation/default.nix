{ options, config, lib, pkgs, ... }:
with lib;
let cfg = config.plusultra.archetypes.workstation;
in {
  options.plusultra.archetypes.workstation = with types; {
    enable =
      mkBoolOpt false "Whether or not to enable the workstation archetype.";
  };

  config = mkIf cfg.enable {
    plusultra.suites = {
      common = enabled;
      desktop = enabled;
      development = enabled;
      art = enabled;
      business = enabled;
      video = enabled;
      social = enabled;
      media = enabled;
    };
  };
}
