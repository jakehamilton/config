{
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.apps.yt-music;
in
{
  options.${namespace}.apps.yt-music = with types; {
    enable = mkBoolOpt false "Whether or not to enable YouTube Music.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs.plusultra; [ yt-music ]; };
}
