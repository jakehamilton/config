{ options, config, lib, pkgs, ... }:
with lib;
let cfg = config.plusultra.suites.art;
in {
  options.plusultra.suites.art = with types; {
    enable = mkBoolOpt false "Whether or not to enable art configuration.";
  };

  config = mkIf cfg.enable {
    plusultra = {
      apps = {
        gimp = enabled;
        inkscape = enabled;
        blender = enabled;
      };
    };
  };
}
