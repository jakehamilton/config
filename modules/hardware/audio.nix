{ options, config, pkgs, lib, ... }:

with lib;
let cfg = config.ultra.hardware.audio;
in {
  options.ultra.hardware.audio = with types; {
    enable = mkBoolOpt true "Whether or not to enable audio support.";
  };

  config = mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      pulse.enable = true;
    };

    hardware.pulseaudio.enable = mkForce false;

    environment.systemPackages = with pkgs; [ pulsemixer ];

    ultra.home.extraOptions = {
      systemd.user.services.mpris-proxy = {
        Unit.Description = "Mpris proxy";
        Unit.After = [ "network.target" "sound.target" ];
        Service.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
        Install.WantedBy = [ "default.target" ];
      };
    };
  };
}
