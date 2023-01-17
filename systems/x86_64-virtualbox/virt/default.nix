{ pkgs, lib, ... }:

with lib;
with lib.internal;
{
  virtualisation.virtualbox.guest.enable = true;

  boot.loader.grub.enable = true;

  programs.sway.extraSessionCommands = ''
    WLR_NO_HARDWARE_CURSORS=1
  '';

  plusultra = {
    nix = enabled;

    apps = {
      _1password = enabled;
      firefox = enabled;
      logseq = enabled;
      vscode = enabled;
    };

    cli-apps = { neovim = enabled; };

    desktop = {
      gnome = {
        enable = true;
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
    };

    hardware = {
      audio = enabled;
      networking = enabled;
    };

    services = { printing = enabled; };

    security = {
      doas = enabled;
      keyring = enabled;
    };

    system = {
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
