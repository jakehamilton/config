{ options, config, pkgs, lib, ... }:

with lib;
let cfg = config.plusultra.hardware.audio;
in {
  options.plusultra.hardware.audio = with types; {
    enable = mkBoolOpt false "Whether or not to enable audio support.";
  };

  config = mkIf cfg.enable {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };

    hardware.pulseaudio.enable = mkForce false;

    environment.systemPackages = with pkgs; [ pulsemixer ];

    plusultra.home.extraOptions = {
      systemd.user.services.mpris-proxy = {
        Unit.Description = "Mpris proxy";
        Unit.After = [ "network.target" "sound.target" ];
        Service.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
        Install.WantedBy = [ "default.target" ];
      };
    };
  };
}
