{ pkgs, config, lib, ... }:

with lib;
with lib.internal;
{
  imports = [ ./hardware.nix ];

  services.minio = {
    enable = true;

    region = "us-west-1";

    dataDir = [ "/persist/apps/minio/data" ];
    configDir = "/persist/apps/minio/config";

    rootCredentialsFile = "/persist/apps/minio/credentials";
  };

  services.navidrome = {
    enable = true;

    settings = {
      Address = "127.0.0.1";
      Port = 4533;
      MusicFolder = "/persist/share/audio/music";
      EnableGravatar = "true";
    };
  };

  services.jellyfin.enable = true;

  networking.firewall.allowedTCPPorts = [
    # Navidrome
    4533

    # Jellyfin
    8096
  ];
  networking.firewall.allowedUDPPorts = [
    # Jellyfin
    1900
    7359
  ];

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
      icehouse = enabled;
    };

    hardware = {
      networking = enabled;
    };

    services = {
      openssh = enabled;
      tailscale = enabled;

      cowsay-mastodon-poster = {
        enable = true;
        short = true;
      };

      vault = {
        enable = true;

        policies =
          builtins.foldl'
            (policies: file: policies // {
              "${snowfall.path.get-file-name-without-extension file}" = file;
            })
            { }
            (builtins.filter (snowfall.path.has-file-extension "hcl")
              (builtins.map
                (path:
                  ./vault/policies +
                  "/${builtins.baseNameOf (builtins.unsafeDiscardStringContext path)}"
                )
                (snowfall.fs.get-files ./vault/policies)));
      };


      samba = {
        enable = true;

        shares = {
          audio = {
            path = "/persist/share/audio";
            public = true;
            only-owner-editable = true;
          };
          video = {
            path = "/persist/share/video";
            public = true;
            only-owner-editable = true;
          };
          books = {
            path = "/persist/share/books";
            public = true;
            only-owner-editable = true;
          };
          homes = {
            path = "/persist/share/homes/%S";
            browseable = false;
            public = false;

            extra-config = {
              "guest ok" = "no";
            };
          };
          documents = {
            path = "/persist/share/documents";

            # For configuration options, see: man 5 smb.conf
            extra-config = {
              "create mask" = "0755";
              "write list" = config.plusultra.user.name;
              "read list" = config.plusultra.user.name;
            };
          };
          vault = {
            path = "/persist/share/vault";

            extra-config = {
              "create mask" = "0755";
              "write list" = config.plusultra.user.name;
              "read list" = config.plusultra.user.name;
            };
          };
        };
      };
    };

    security = {
      doas = enabled;
      gpg = enabled;
      acme = enabled;
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
    defaults = {
      dnsProvider = "digitalocean";
      dnsPropagationCheck = true;

      credentialsFile = "/var/lib/acme-secrets/digitalocean";
    };

    certs."quartz.hamho.me" = {
      domain = "*.quartz.hamho.me";
    };
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;

    virtualHosts =
      let
        shared-config = {
          extra-config = {
            forceSSL = true;

            sslCertificate = "${config.security.acme.certs."quartz.hamho.me".directory}/fullchain.pem";
            sslCertificateKey = "${config.security.acme.certs."quartz.hamho.me".directory}/key.pem";
          };
        };
      in
      {
        "minio.quartz.hamho.me" =
          network.create-proxy
            ((network.get-address-parts config.services.minio.consoleAddress)
              // shared-config);

        "jellyfin.quartz.hamho.me" = network.create-proxy ({
          # https://jellyfin.org/docs/general/networking/index.html#static-ports
          port = 8096;

          # This is required to support sync play.
          proxy-web-sockets = true;
        } // shared-config);

        "navidrome.quartz.hamho.me" = network.create-proxy ({
          # https://www.navidrome.org/docs/usage/configuration-options/#available-options
          port = 4533;
        } // shared-config);

        "vault.quartz.hamho.me" = network.create-proxy
          ((network.get-address-parts config.services.vault.address)
            // shared-config);
      };
  };

  system.stateVersion = "21.11";
}
