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
          traek.enable = true;
          dotbox.enable = true;
          noop-ai.enable = true;
          sokoban.enable = true;
          jakehamilton.enable = true;
          beyondthefringeoc.enable = true;
          snowfall.enable = true;
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
