{
  lib,
  pkgs,
  config,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
{
  imports = [ ./hardware.nix ];

  plusultra = {
    nix = enabled;

    cli-apps = {
      neovim = enabled;
      tmux = enabled;
    };

    tools = {
      git = enabled;
      misc = enabled;
      fup-repl = enabled;
      comma = enabled;
      nix-ld = enabled;
      bottom = enabled;
    };

    hardware = {
      networking = enabled;
    };

    services = {
      openssh = enabled;
      tailscale = enabled;
      palworld = enabled;
      local-ai = enabled;
    };

    security = {
      doas = enabled;
      acme = {
        enable = false;
      };
    };

    virtualisation = {
      podman = enabled;
    };

    system = {
      boot = enabled;
      fonts = enabled;
      locale = enabled;
      time = enabled;
      xkb = enabled;
      zfs = {
        enable = true;
        auto-snapshot = enabled;
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults = {
      dnsProvider = "digitalocean";
      dnsPropagationCheck = true;

      credentialsFile = "/var/lib/acme-secrets/digitalocean";
    };

    # certs."ruby.hamho.me" = {
    #   domain = "*.ruby.hamho.me";
    # };
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;

    clientMaxBodySize = "256m";

    virtualHosts =
      let
        shared-config = {
          extra-config = {
            forceSSL = true;

            sslCertificate = "${config.security.acme.certs."ruby.hamho.me".directory}/fullchain.pem";
            sslCertificateKey = "${config.security.acme.certs."ruby.hamho.me".directory}/key.pem";
          };
        };
      in
      { };
  };

  system.stateVersion = "22.05";
}
