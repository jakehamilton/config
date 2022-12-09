{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.apps.yt-music;
in
{
  options.plusultra.apps.yt-music = with types; {
    enable = mkBoolOpt false "Whether or not to enable YouTube Music.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs.plusultra; [ yt-music ]; };
}
