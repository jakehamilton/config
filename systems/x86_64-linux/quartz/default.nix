{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
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
        enable = false;

        policies =
          builtins.foldl'
            (policies: file: policies // { "${snowfall.path.get-file-name-without-extension file}" = file; })
            { }
            (
              builtins.filter (snowfall.path.has-file-extension "hcl") (
                builtins.map (
                  path: ./vault/policies + "/${builtins.baseNameOf (builtins.unsafeDiscardStringContext path)}"
                ) (snowfall.fs.get-files ./vault/policies)
              )
            );
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
              "write list" = config.${namespace}.user.name;
              "read list" = config.${namespace}.user.name;
            };
          };
          vault = {
            path = "/persist/share/vault";

            extra-config = {
              "create mask" = "0755";
              "write list" = config.${namespace}.user.name;
              "read list" = config.${namespace}.user.name;
            };
          };
        };
      };

      homer = {
        enable = true;
        host = "hamho.me";

        package = pkgs.plusultra.homer-catppuccin.override { favicon = "light"; };

        settings = {
          title = "Dashboard";
          subtitle = "Hamilton Home";

          logo = pkgs.plusultra.homer-catppuccin.logos.light;

          stylesheet = [
            pkgs.plusultra.homer-catppuccin.stylesheets.latte
            pkgs.plusultra.homer-catppuccin.stylesheets.frappe
          ];

          footer = "";

          connectivityCheck = true;

          columns = "auto";

          defaults = {
            layout = "list";
            colorTheme = "auto";
          };

          services = [
            {
              name = "Media";
              icon = "fas fa-photo-film";
              items = [
                {
                  name = "Jellyfin";
                  icon = "fas fa-film";
                  url = "https://jellyfin.quartz.hamho.me";
                  target = "_blank";
                }
                {
                  name = "Navidrome";
                  icon = "fas fa-music";
                  url = "https://navidrome.quartz.hamho.me";
                  target = "_blank";
                }
              ];
            }
            {
              name = "Social";
              icon = "fas fa-users";
              items = [
                {
                  name = "Mastodon";
                  icon = "fas fa-comment";
                  url = "https://elk.zone/home";
                  target = "_blank";
                }
              ];
            }
            {
              name = "Blog";
              icon = "fas fa-pencil";
              items = [
                {
                  name = "uncertain.ink";
                  icon = "fas fa-book";
                  url = "https://uncertain.ink";
                  target = "_blank";
                }
                {
                  name = "bytesize.xyz";
                  icon = "fas fa-cubes";
                  url = "https://bytesize.xyz";
                  target = "_blank";
                }
                {
                  name = "kilo.bytesize.xyz";
                  icon = "fas fa-code";
                  url = "https://kilo.bytesize.xyz";
                  target = "_blank";
                }
              ];
            }
            {
              name = "Administration";
              icon = "fas fa-shield-halved";
              items = [
                {
                  name = "Documentation";
                  icon = "fas fa-note-sticky";
                  url = "https://github.com/jakehamilton/notes";
                  target = "_blank";
                }
                {
                  name = "Vault";
                  icon = "fas fa-lock";
                  url = "https://vault.quartz.hamho.me";
                  target = "_blank";
                }
                {
                  name = "Hydra";
                  icon = "fas fa-dragon";
                  url = "https://hydra.quartz.hamho.me";
                  target = "_blank";
                }
              ];
            }
          ];
        };

        # settings-path = "/var/lib/homer/config.yml";
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

    certs."hamho.me" = {
      domain = "hamho.me";
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
        "hamho.me" = {
          forceSSL = mkForce true;

          sslCertificate = "${config.security.acme.certs."hamho.me".directory}/fullchain.pem";
          sslCertificateKey = "${config.security.acme.certs."hamho.me".directory}/key.pem";
        };

        "minio.quartz.hamho.me" = network.create-proxy (
          (network.get-address-parts config.services.minio.consoleAddress) // shared-config
        );

        "jellyfin.quartz.hamho.me" = network.create-proxy (
          {
            # https://jellyfin.org/docs/general/networking/index.html#static-ports
            port = 8096;

            # This is required to support sync play.
            proxy-web-sockets = true;
          }
          // shared-config
        );

        "navidrome.quartz.hamho.me" = network.create-proxy (
          {
            # https://www.navidrome.org/docs/usage/configuration-options/#available-options
            port = 4533;
          }
          // shared-config
        );

        "vault.quartz.hamho.me" = network.create-proxy (
          (network.get-address-parts config.services.vault.address) // shared-config
        );
      };
  };

  system.stateVersion = "21.11";
}
