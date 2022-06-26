{ pkgs, config, lib, ... }:

# @TODO(jakehamilton): Move this to my Logseq notes.
# Wine Shenanigans (to run Cave Story):
# 1. Install Lutris and select the game "Final Fantasy XIV Online" to install.
# 2. Proceed with the installer until it wants to install the game and then click cancel.
# 3. Finish with the Lutris installer and open a terminal. Run the following:
#   WINEPREFIX=/home/short/Games/final-fantasy-xiv-online wine64 ../Cave\ Story\ Multiplayer/Doukutsu.exe
# 4. The `final-fantasy-xiv-online` directory can be renamed/moved, or have its contents copied.
#   to the default Wine prefix if preferred.
# **NOTE**: wine-wow (wine64) is required to run in this prefix, so the package `wine64Packages.unstable`
#   should be installed.

with lib; {
  imports = [ ./hardware.nix ];

  networking.firewall.allowedTCPPorts = [ 12345 3000 3001 8080 8081 ];

  environment.systemPackages = with pkgs; [
    chromium
    kalidoface-2d
    kalidoface-3d
  ];

  services.samba-wsdd = enabled;

  services.samba = {
    enable = true;
    openFirewall = true;
    shares = {
      video = {
        path = "/mnt/data/video";
        comment = "Video";
        browseable = "yes";
        public = "yes";
        "read only" = "yes";
      };
      audio = {
        path = "/mnt/data/audio";
        comment = "Audio";
        browseable = "yes";
        public = "yes";
        "read only" = "yes";
      };
      shared = {
        path = "/mnt/data/shared";
        comment = "Shared files";
        browseable = "yes";
        public = "yes";
        "read only" = "no";
      };
    };
  };

  plusultra = {
    archetypes = {
      gaming = enabled;
      workstation = enabled;
    };

    desktop.gnome.wallpaper =
      pkgs.plusultra.wallpapers.pink-and-blue-ultrawide.fileName;

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
