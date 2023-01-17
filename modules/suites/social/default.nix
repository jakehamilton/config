{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.plusultra.suites.social;
in
{
  options.plusultra.suites.social = with types; {
    enable = mkBoolOpt false "Whether or not to enable social configuration.";
  };

  config = mkIf cfg.enable {
    plusultra = {
      apps = {
        discord = {
          enable = true;
          chromium = enabled;
        };
        element = enabled;
      };
    };
  };
}
