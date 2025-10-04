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

    systemd.tmpfiles.settings = {
      "5-nginx"."/var/lib/nginx/cache".d = {
        user = "nginx";
        group = "nginx";
        mode = "0750";
      };
    };

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

        openfront = {
          enable = true;
          host = "terminalconflict.io";
          environmentFile = "/var/secrets/openfront";
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
