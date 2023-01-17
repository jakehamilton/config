{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.plusultra.suites.video;
in
{
  options.plusultra.suites.video = with types; {
    enable = mkBoolOpt false "Whether or not to enable video configuration.";
  };

  config = mkIf cfg.enable {
    plusultra = {
      apps = {
        pitivi = enabled;
        obs = enabled;
      };
    };
  };
}
