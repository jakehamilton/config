{ pkgs, lib, ... }:

with lib;
{
  imports = [ ./hardware.nix ];

  ultra = {
    nix = enabled;

    apps = {
      _1password = enabled;
      discord = enabled;
      firefox = enabled;
      steam = enabled;
      vscode = enabled;
    };

    cli-apps = {
      neovim = enabled;
    };

    desktop = {
      gnome = disabled;
      sway = enabled;
    };

    tools = {
      git = enabled;
      misc = enabled;
    };

    hardware = {
      audio = enabled;
      networking = enabled;
      fingerprint = enabled;
    };

    services = {
      printing = enabled;
    };

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
