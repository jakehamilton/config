{
  lib,
  pkgs,
  modulesPath,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
{
  imports = [ (modulesPath + "/virtualisation/digital-ocean-config.nix") ];

  virtualisation.digitalOcean = {
    rebuildFromUserData = false;
  };

  boot.loader.grub = enabled;

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  environment.systemPackages = with pkgs; [ neovim ];

  plusultra = {
    nix = enabled;

    cli-apps = {
      tmux = enabled;
      # neovim = enabled;
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
        pungeonquest = enabled;
        nixpkgs-news = enabled;
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
