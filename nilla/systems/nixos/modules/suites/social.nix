{ lib, config, ... }:
let
  cfg = config.plusultra.suites.social;
in
{
  options.plusultra.suites.social = {
    enable = lib.mkEnableOption "the social suite";
  };

  config = lib.mkIf cfg.enable {
    plusultra = {
      apps = {
        discord = {
          enable = true;
          chromium = true;
        };
      };
    };
  };
}
