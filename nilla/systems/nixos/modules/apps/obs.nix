{ lib
, config
, pkgs
, ...
}:
let
  cfg = config.plusultra.apps.obs;
in
{
  options.plusultra.apps.obs = {
    enable = lib.mkEnableOption "OBS";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (wrapOBS {
        plugins = with obs-studio-plugins; [
          wlrobs
          obs-multi-rtmp
          obs-move-transition
        ];
      })
    ];
  };
}
