{ lib
, config
, pkgs
, ...
}:
let
  cfg = config.plusultra.hardware.audio;
in
{
  options.plusultra.hardware.audio = {
    enable = lib.mkEnableOption "Audio support";
  };

  config = lib.mkIf cfg.enable {
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;

      wireplumber.enable = true;
    };

    hardware.pulseaudio.enable = lib.mkForce false;

    environment.systemPackages = with pkgs; [
      pulsemixer
      pavucontrol
      qjackctl
      easyeffects
    ];

    plusultra.user.extraGroups = [ "audio" ];
  };
}
