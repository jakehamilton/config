{ pkgs, lib, ... }:

with lib;
with lib.internal;
{
  plusultra = {
    nix = enabled;

    cli-apps = { neovim = enabled; };

    tools = {
      misc = enabled;
      git = enabled;
      http = enabled;
    };

    hardware = { networking = enabled; };

    security = { doas = enabled; };

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
