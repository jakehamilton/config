{ config, pkgs, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/virtualisation/digital-ocean-config.nix")
  ];

  config = {

    virtualisation.digitalOcean = {
      rebuildFromUserData = false;
    };

    boot.loader.grub.enable = true;

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

    environment.systemPackages = with pkgs; [ neovim ];

    plusultra = {
      nix.enable = true;

      cli-apps = {
        tmux.enable = true;
      };

      tools = {
        git.enable = true;
      };

      security = {
        doas.enable = true;
        acme.enable = true;
      };

      services = {
        openssh.enable = true;
        tailscale.enable = true;

        websites = {
          pungeonquest.enable = true;
          nilla-dev.enable = true;
          nixpkgs-news.enable = true;
        };
      };

      system = {
        fonts.enable = true;
        locale.enable = true;
        time.enable = true;
        xkb.enable = true;
      };
    };

    system.stateVersion = "21.11";
  };
}
