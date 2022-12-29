{ lib, pkgs, ... }:

let
  tailscale-key = builtins.getEnv "TAILSCALE_AUTH_KEY";
in
with lib;
{
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
      tailscale = {
        enable = true;
        autoconnect = {
          enable = tailscale-key != "";
          key = tailscale-key;
        };
      };
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
