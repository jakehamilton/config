{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.apps.obs;
in {
  options.plusultra.apps.obs = with types; {
    enable = mkBoolOpt false "Whether or not to enable support for OBS.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      (pkgs.wrapOBS {
        plugins = with pkgs.obs-studio-plugins; [
          wlrobs
          obs-websocket
          obs-multi-rtmp
          obs-move-transition
          looking-glass-obs
        ];
      })
    ];
  };
}
