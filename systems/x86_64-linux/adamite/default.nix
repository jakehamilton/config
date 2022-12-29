{ lib, pkgs, modulesPath, ... }:

with lib;
{
  imports = [
    (modulesPath + "/virtualisation/digital-ocean-config.nix")
  ];

  virtualisation.digitalOcean = {
    rebuildFromUserData = false;
  };

  boot.loader.grub = enabled;

  environment.systemPackages = with pkgs; [
    neovim
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

  system.stateVersion = "21.11";
}
