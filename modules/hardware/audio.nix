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

      media-session.config.alsa-monitor = {
        rules = [
          {
            matches =
              [{ "node.name" = "alsa_output.pci-0000_31_00.4.analog-stereo"; }];
            actions = {
              "update-props" = { "node.description" = "Speakers"; };
            };
          }
          {
            matches = [{
              "node.name" =
                "alsa_input.usb-Valve_Corporation_Valve_VR_Radio___HMD_Mic_426C59CC3D-LYM-01.mono-fallback";
            }];
            actions = {
              "update-props" = { "node.description" = "Valve Index"; };
            };
          }
          {
            matches = [{
              "node.name" =
                "alsa_output.usb-Blue_Microphones_Yeti_Stereo_Microphone_797_2020_06_11_32800-00.analog-stereo";
            }];
            actions = {
              "update-props" = { "node.description" = "Blue Yeti"; };
            };
          }
        ];
      };

      config.pipewire = {
        "context.objects" = [
          {
            factory = "adapter";
            args = {
              "factory.name" = "support.null-audio-sink";
              "node.name" = "virtual-desktop-audio";
              "node.description" = "Desktop Audio (Virtual)";
              "media.class" = "Audio/Duplex";
              "object.linger" = true;
              "audio.position" = [ "FL" "FR" ];
              "monitor.channel-volumes" = true;
            };
          }
          {
            factory = "adapter";
            args = {
              "factory.name" = "support.null-audio-sink";
              "node.name" = "virtual-discord-audio";
              "node.description" = "Discord Audio (Virtual)";
              "media.class" = "Audio/Duplex";
              "object.linger" = true;
              "audio.position" = [ "FL" "FR" ];
              "monitor.channel-volumes" = true;
            };
          }
          {
            factory = "adapter";
            args = {
              "factory.name" = "support.null-audio-sink";
              "node.name" = "virtual-headphones-audio";
              "node.description" = "Headphones (Virtual)";
              "media.class" = "Audio/Sink";
              "object.linger" = true;
              "audio.position" = [ "FL" "FR" ];
              "monitor.channel-volumes" = true;
            };
          }
          {
            factory = "adapter";
            args = {
              "factory.name" = "support.null-audio-sink";
              "node.name" = "virtual-speakers-audio";
              "node.description" = "Speakers (Virtual)";
              "media.class" = "Audio/Sink";
              "object.linger" = true;
              "audio.position" = [ "FL" "FR" ];
              "monitor.channel-volumes" = true;
            };
          }
        ];
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
          {
            name = "libpipewire-module-loopback";
            args = {
              "node.name" = "speakers-bridge";
              "node.passive" = false;
              "audio.position" = [ "FL" "FR" ];
              "monitor.channel-volumes" = true;
              "capture.props" = { "node.target" = "virtual-speakers-audio"; };
              "playback.props" = {
                "monitor.channel-volumes" = true;
                "node.target" = "alsa_output.pci-0000_31_00.4.analog-stereo";
              };
            };
          }
          {
            name = "libpipewire-module-loopback";
            args = {
              "node.name" = "headphones-bridge";
              "audio.position" = [ "FL" "FR" ];

              "monitor.channel-volumes" = true;
              "capture.props" = { "node.target" = "virtual-headphones-audio"; };
              "playback.props" = {
                "monitor.channel-volumes" = true;
                "node.target" =
                  "alsa_output.usb-Blue_Microphones_Yeti_Stereo_Microphone_797_2020_06_11_32800-00.analog-stereo";
              };
            };
          }
          {
            name = "libpipewire-module-loopback";
            args = {
              "node.name" = "desktop-audio-bridge (Speakers)";
              "audio.position" = [ "FL" "FR" ];
              "monitor.channel-volumes" = true;
              "capture.props" = { "node.target" = "virtual-speakers-audio"; };
              "playback.props" = {
                "node.target" = "virtual-desktop-audio";
                "monitor.channel-volumes" = true;
              };
            };
          }
          {
            name = "libpipewire-module-loopback";
            args = {
              "node.name" = "desktop-audio-bridge (Headphones)";
              "audio.position" = [ "FL" "FR" ];
              "stream.props" = { "volume" = 0.5; };
              "capture.props" = { "node.target" = "virtual-headphones-audio"; };
              "playback.props" = {
                "node.target" = "virtual-desktop-audio";
                "monitor.channel-volumes" = true;
              };
            };
          }
          {
            name = "libpipewire-module-loopback";
            args = {
              "node.name" = "default-bridge";
              "audio.position" = [ "FL" "FR" ];
              "monitor.channel-volumes" = true;
              "capture.props" = {
                # Disables the capture
                "media.class" = "Audio/Source";
                # This doesn't work, instead it selects the monitor for the default *source*:
                # "node.target" = "@DEFAULT_SINK@";

                # This does work, but will only ever be this named device:
                # "node.target" = "alsa_output.pci-0000_31_00.4.analog-stereo";
              };
              "playback.props" = {
                "monitor.channel-volumes" = true;
                "node.target" = "virtual-desktop-audio";
                # "node.target" = "@DEFAULT_SINK@";
                # "audio.position" = [ "FL" "FR" ];
              };
            };
          }
        ];
      };
    };

    hardware.pulseaudio.enable = mkForce false;

    environment.systemPackages = with pkgs; [ pulsemixer ];

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
