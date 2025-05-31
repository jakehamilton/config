{ config, pkgs, ... }:
{
  imports = [ ./hardware.nix ];

  config = {
    boot = {
      binfmt.emulatedSystems = [ "aarch64-linux" ];

      # NOTE: This _may_ be required for openvpn to work. However, I have
      # not confirmed that...
      kernelModules = [ "tun" ];
    };

    services.ollama = {
      enable = true;
      acceleration = "rocm";
      rocmOverrideGfx = "10.1.0";
    };

    services.nextjs-ollama-llm-ui = {
      enable = true;
      ollamaUrl = "http://127.0.0.1:11434";
      port = 5950;
      hostname = "0.0.0.0";
    };

    plusultra = {
      archetypes = {
        gaming.enable = true;
        workstation.enable = true;
      };

      services = {
        avahi.enable = true;

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

      desktop.gnome = {
        wallpaper = {
          # light = pkgs.plusultra.wallpapers.nord-rainbow-light-nix-ultrawide;
          # dark = pkgs.plusultra.wallpapers.nord-rainbow-dark-nix-ultrawide;
        };
        monitors = ./monitors.xml;
      };

      virtualisation.kvm = {
        enable = true;
        platform = "amd";
        # RX480 when in the bottom slot:
        # IOMMU Group 23 23:00.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc. [AMD/ATI] Ellesmere [Radeon RX 470/480/570/570X/580/580X/590] [1002:67df] (rev c7)
        # IOMMU Group 23 23:00.1 Audio device [0403]: Advanced Micro Devices, Inc. [AMD/ATI] Ellesmere HDMI Audio [Radeon RX 470/480 / 570/580/590] [1002:aaf0]
        vfioIds = [
          "1002:67df"
          "1002:aaf0"
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
  };
}
