{ lib, config, ... }:
let
  cfg = config.plusultra.suites.games;
in
{
  options.plusultra.suites.games = {
    enable = lib.mkEnableOption "the games suite";
  };

  config = lib.mkIf cfg.enable {
    plusultra = {
      apps = {
        steam.enable = true;
        prismlauncher.enable = true;
        bottles.enable = true;
      };
    };
  };
}
