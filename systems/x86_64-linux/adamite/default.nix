{ lib, pkgs, modulesPath, ... }:

with lib;
{
  imports = [
    (modulesPath + "/virtualisation/digital-ocean-config.nix")
  ];

  virtualisation.digitalOcean = {
    rebuildFromUserData = false;
  };

  environment.systemPackages = with pkgs; [
    neovim
  ];

  plusultra = {
    nix = enabled;

    cli-apps = {
      tmux = enabled;
    };

    tools = {
      git = enabled;
    };

    security = {
      doas = enabled;
    };

    services = {
      openssh = enabled;
      tailscale = enabled;
    };

    system = {
      fonts = enabled;
      locale = enabled;
      time = enabled;
      xkb = enabled;
    };
  };

  boot.loader.grub = {
    enable = true;
  };

  system.stateVersion = "21.11";
}
