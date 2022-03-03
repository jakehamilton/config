{ pkgs, lib, ... }:

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

  environment.systemPackages = with pkgs; [
    helvum
    easyeffects
    carla
    qjackctl
    pavucontrol
    wineUnstable
    winetricks
    wine64Packages.unstable
    lutris
    ardour
  ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

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

  services.samba-wsdd = { enable = true; };

  plusultra = {
    nix = enabled;

    apps = {
      _1password = enabled;
      discord = {
        enable = true;
        chromium = enabled;
      };
      cadence = enabled;
      element = enabled;
      gparted = enabled;
      firefox = enabled;
      logseq = enabled;
      vscode = enabled;
      pitivi = enabled;
      steam = enabled;
      obs = enabled;
      yubikey = enabled;
      virtualbox = enabled;
      vlc = enabled;
    };

    cli-apps = {
      neovim = enabled;
      wshowkeys = enabled;
      yubikey = enabled;
    };

    desktop = {
      gnome = {
        enable = true;
        wallpaper = pkgs.plusultra.wallpapers.atmosphere.fileName;
      };

      addons = {
        # I like to have a convenient place to share wallpapers from
        # even if they're not currently being used.
        wallpapers = enabled;
      };
    };

    tools = {
      k8s = enabled;
      git = enabled;
      node = enabled;
      http = enabled;
      misc = enabled;
      titan = enabled;
      at = enabled;
    };

    hardware = {
      audio = enabled;
      networking = enabled;
      storage = enabled;
    };

    services = { printing = enabled; };

    security = {
      doas = enabled;
      keyring = enabled;
    };

    system = {
      boot = enabled;
      fonts = enabled;
      locale = enabled;
      time = enabled;
      xkb = enabled;
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
