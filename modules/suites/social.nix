{ options, config, lib, pkgs, ... }:
with lib;
let cfg = config.plusultra.suites.social;
in {
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
