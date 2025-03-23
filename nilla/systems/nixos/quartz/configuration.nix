{ lib, config, pkgs, project, ... }:
let
  homer-catppuccin = project.packages.homer-catppuccin.result.${pkgs.system};
in
{
  imports = [ ./hardware.nix ];

  config = {
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
      nix.enable = true;

      cli-apps = {
        neovim.enable = true;
        tmux.enable = true;
      };

      tools = {
        git.enable = true;
        misc.enable = true;
        comma.enable = true;
        bottom.enable = true;
        icehouse.enable = true;
      };

      hardware = {
        networking.enable = true;
      };

      services = {
        openssh.enable = true;
        tailscale.enable = true;

        cowsay-mastodon-poster = {
          enable = true;
          short = true;
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

        homer = {
          enable = true;
          host = "hamho.me";

          package = homer-catppuccin.override { favicon = "light"; };

          settings = {
            title = "Dashboard";
            subtitle = "Hamilton Home";

            logo = homer-catppuccin.logos.light;

            stylesheet = [
              homer-catppuccin.stylesheets.latte
              homer-catppuccin.stylesheets.frappe
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
                ];
              }
            ];
          };
        };
      };

      security = {
        doas.enable = true;
        gpg.enable = true;
        acme.enable = true;
      };

      system = {
        boot.enable = true;
        fonts.enable = true;
        locale.enable = true;
        time.enable = true;
        xkb.enable = true;
        zfs = {
          enable = true;
          auto-snapshot.enable = true;
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
            forceSSL = lib.mkForce true;

            sslCertificate = "${config.security.acme.certs."hamho.me".directory}/fullchain.pem";
            sslCertificateKey = "${config.security.acme.certs."hamho.me".directory}/key.pem";
          };

          "minio.quartz.hamho.me" = project.lib.network.create-proxy (
            (project.lib.network.get-address-parts config.services.minio.consoleAddress) // shared-config
          );

          "jellyfin.quartz.hamho.me" = project.lib.network.create-proxy (
            {
              # https://jellyfin.org/docs/general/networking/index.html#static-ports
              port = 8096;

              # This is required to support sync play.
              proxy-web-sockets = true;
            }
            // shared-config
          );

          "navidrome.quartz.hamho.me" = project.lib.network.create-proxy (
            {
              # https://www.navidrome.org/docs/usage/configuration-options/#available-options
              port = 4533;
            }
            // shared-config
          );
        };
    };

    system.stateVersion = "21.11";
  };
}
