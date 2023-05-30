{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.plusultra.suites.music;
in
{
  options.plusultra.suites.music = with types; {
    enable = mkBoolOpt false "Whether or not to enable music configuration.";
  };

  config = mkIf cfg.enable {
    plusultra = {
      apps = {
        ardour = enabled;
        bottles = enabled;
      };
    };
  };
}
