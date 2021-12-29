inputs@{ pkgs, lib, ... }:

lib.mkSystem {
  # Hardware configuration for the system.
  hardware = ./hardware.nix;

  suites = [
    "nixos"
    "desktop"
    "apps"
    "games"
    "dev"
  ];

  presets = [
  ];

  modules = [
    "fprintd"
  ];

  users = [
    "short"
  ];

  config = {
    # Enable DHCP on the wireless link
    networking.interfaces.wlp0s20f3.useDHCP = true;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "21.11"; # Did you read the comment?
  };
}
