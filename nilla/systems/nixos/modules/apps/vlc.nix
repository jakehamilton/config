{ lib
, config
, pkgs
, ...
}:
let
  cfg = config.plusultra.apps.vlc;
in
{
  options.plusultra.apps.vlc = {
    enable = lib.mkEnableOption "VLC";
  };

  config = lib.mkIf cfg.enable { environment.systemPackages = with pkgs; [ vlc ]; };
}
