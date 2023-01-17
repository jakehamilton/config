{ lib, pkgs, modulesPath, ... }:

with lib;
with lib.internal;
{
  imports = [
    (modulesPath + "/virtualisation/digital-ocean-config.nix")
  ];

  virtualisation.digitalOcean = {
    rebuildFromUserData = false;
  };

  boot.loader.grub = enabled;

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  plusultra = {
    nix = enabled;

    cli-apps = {
      tmux = enabled;
      neovim = enabled;
    };

    tools = {
      git = enabled;
    };

    security = {
      doas = enabled;
      acme = enabled;
    };

    services = {
      openssh = enabled;
      tailscale = enabled;

      websites = {
        traek = enabled;
        dotbox = enabled;
        sokoban = enabled;
        jakehamilton = enabled;
        beyondthefringeoc = enabled;
      };
    };

    system = {
      fonts = enabled;
      locale = enabled;
      time = enabled;
      xkb = enabled;
    };
  };

  system.stateVersion = "21.11";
}
