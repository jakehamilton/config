{ options, config, pkgs, lib, ... }:

with lib;
let
  cfg = config.ultra.hardware.audio;
in
{
  options.ultra.hardware.audio = with types; {
    enable = mkBoolOpt true "Whether or not to enable audio support.";
  };

  config = mkIf cfg.enable {
    sound.enable = true;
    hardware.pulseaudio.enable = true;
  };
}
