{ options, config, pkgs, lib, ... }:

with lib;
with lib.internal;
let
  cfg = config.plusultra.hardware.audio;

  pipewire-config = {
    "context.objects" = cfg.nodes ++ [ ];
    "context.modules" = [
      {
        name = "libpipewire-module-rtkit";
        args = { };
        flags = [ "ifexists" "nofail" ];
      }
      { name = "libpipewire-module-protocol-native"; }
      { name = "libpipewire-module-profiler"; }
      { name = "libpipewire-module-metadata"; }
      { name = "libpipewire-module-spa-device-factory"; }
      { name = "libpipewire-module-spa-node-factory"; }
      { name = "libpipewire-module-client-node"; }
      { name = "libpipewire-module-client-device"; }
      {
        name = "libpipewire-module-portal";
        flags = [ "ifexists" "nofail" ];
      }
      {
        name = "libpipewire-module-access";
        args = { };
      }
      { name = "libpipewire-module-adapter"; }
      { name = "libpipewire-module-link-factory"; }
      { name = "libpipewire-module-session-manager"; }
    ] ++ cfg.modules;
  };

  alsa-config = {
    alsa_monitor = cfg.alsa-monitor;
  };
in
{
  options.plusultra.hardware.audio = with types; {
    enable = mkBoolOpt false "Whether or not to enable audio support.";
    alsa-monitor = mkOpt attrs { } "Alsa configuration.";
    nodes = mkOpt (listOf attrs) [ ]
      "Audio nodes to pass to Pipewire as `context.objects`.";
    modules = mkOpt (listOf attrs) [ ]
      "Audio modules to pass to Pipewire as `context.modules`.";
    extra-packages = mkOpt (listOf package) [
      pkgs.qjackctl
      pkgs.easyeffects
    ] "Additional packages to install.";
  };

  config = mkIf cfg.enable {
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;

      wireplumber.enable = true;
    };

    environment.etc = {
      "pipewire/pipewire.conf.d/100-pipewire.conf".source =
        pkgs.writeText "pipewire.conf" (builtins.toJSON pipewire-config);
      "pipewire/pipewire.conf.d/110-alsa.conf".source =
        pkgs.writeText "pipewire.conf" (builtins.toJSON alsa-config);
    };

    hardware.pulseaudio.enable = mkForce false;

    environment.systemPackages = with pkgs; [
      pulsemixer
      pavucontrol
    ] ++ cfg.extra-packages;

    plusultra.user.extraGroups = [ "audio" ];

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
