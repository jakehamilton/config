{ pkgs, config, lib, channel, ... }:

with lib;
with lib.internal;
{
  imports = [ ./hardware.nix ];

  # Resolve an issue with Bismuth's wired connections failing sometimes due to weird
  # DHCP issues. I'm not quite sure why this is the case, but I have found that the
  # problem can be resolved by stopping dhcpcd, restarting Network Manager, and then
  # unplugging and replugging the ethernet cable. Perhaps there's some weird race
  # condition when the system is coming up that causes this.
  # networking.dhcpcd.enable = false;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  networking.firewall = {
    allowedUDPPorts = [ 28000 ];
    allowedTCPPorts = [ 28000 ];
  };

  environment.systemPackages = with pkgs;
    [
      chromium
      plusultra.kalidoface
    ];

  services.minecraft-server = {
    enable = false;
    eula = true;
    declarative = true;
    serverProperties = {
      server-port = 43000;
    };
  };

  plusultra = {
    apps = {
      rpcs3 = enabled;
      ubports-installer = enabled;
      steamtinkerlaunch = enabled;
    };

    services = {
      avahi = enabled;

      samba = {
        enable = true;

        shares = {
          video = {
            path = "/mnt/data/video";
            public = true;
            read-only = true;
          };
          audio = {
            path = "/mnt/data/audio";
            public = true;
            read-only = true;
          };
          shared = {
            path = "/mnt/data/shared";
            public = true;
          };
        };
      };

    };

    archetypes = {
      gaming = enabled;
      workstation = enabled;
    };

    desktop.gnome = {
      wallpaper = {
        light = pkgs.plusultra.wallpapers.nord-rainbow-light-nix-ultrawide;
        dark = pkgs.plusultra.wallpapers.nord-rainbow-dark-nix-ultrawide;
      };
      monitors = ./monitors.xml;
    };

    virtualisation.kvm = {
      enable = true;
      platform = "amd";
      # RX480 when in the bottom slot:
      # IOMMU Group 23 23:00.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc. [AMD/ATI] Ellesmere [Radeon RX 470/480/570/570X/580/580X/590] [1002:67df] (rev c7)
      # IOMMU Group 23 23:00.1 Audio device [0403]: Advanced Micro Devices, Inc. [AMD/ATI] Ellesmere HDMI Audio [Radeon RX 470/480 / 570/580/590] [1002:aaf0]
      vfioIds = [ "1002:67df" "1002:aaf0" ];
      machineUnits = [ "machine-qemu\\x2d1\\x2dwin10.scope" ];
    };

    hardware.audio = {
      alsa-monitor.rules = [
        (mkAlsaRename {
          name = "alsa_output.pci-0000_31_00.4.analog-stereo";
          description = "Speakers";
        })
        (mkAlsaRename {
          name =
            "alsa_input.usb-Valve_Corporation_Valve_VR_Radio___HMD_Mic_426C59CC3D-LYM-01.mono-fallback";
          description = "Valve Index";
        })
        (mkAlsaRename {
          name =
            "alsa_output.usb-Blue_Microphones_Yeti_Stereo_Microphone_797_2020_06_11_32800-00.analog-stereo";
          description = "Blue Yeti";
        })
        (mkAlsaRename {
          name =
            "alsa_input.usb-Blue_Microphones_Yeti_Stereo_Microphone_797_2020_06_11_32800-00.analog-stereo";
          description = "Blue Yeti";
        })
      ];

      nodes = [
        (mkVirtualAudioNode { name = "Desktop"; })
        (mkVirtualAudioNode { name = "Discord"; })
        (mkVirtualAudioNode {
          name = "Headphones";
          class = "Audio/Sink";
        })
        (mkVirtualAudioNode {
          name = "Speakers";
          class = "Audio/Sink";
        })
      ];

      modules = [
        (mkBridgeAudioModule {
          name = "speakers";
          from = "virtual-speakers-audio";
          to = "alsa_output.pci-0000_31_00.4.analog-stereo";
        })
        (mkBridgeAudioModule {
          name = "headphones";
          from = "virtual-headphones-audio";
          to =
            "alsa_output.usb-Blue_Microphones_Yeti_Stereo_Microphone_797_2020_06_11_32800-00.analog-stereo";
        })
        (mkBridgeAudioModule {
          name = "speakers-to-desktop";
          from = "virtual-speakers-audio";
          to = "virtual-desktop-audio";
        })
        (mkBridgeAudioModule {
          name = "headphones-to-desktop";
          from = "virtual-headphones-audio";
          to = "virtual-desktop-audio";
        })
      ];
    };
  };

  # WiFi is typically unused on the desktop. Enable this service
  # if it's no longer only using a wired connection.
  systemd.services.network-addresses-wlp41s0.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
