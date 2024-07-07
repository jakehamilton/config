{
  lib,
  pkgs,
  namespace,
  ...
}:
let
  tailscale-key = builtins.getEnv "TAILSCALE_AUTH_KEY";
in
with lib;
with lib.${namespace};
{
  virtualisation.digitalOcean = {
    rebuildFromUserData = false;
  };

  boot.loader.grub = enabled;

  environment.systemPackages = with pkgs; [ neovim ];

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

  system.stateVersion = "21.11";
}
