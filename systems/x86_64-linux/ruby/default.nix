{ lib, pkgs, config, ... }:

with lib;
with lib.internal;
{
  imports = [ ./hardware.nix ];

  plusultra = {
    nix = enabled;

    cache.public = {
      # Ruby runs the cache, it can just use its own store.
      enable = mkForce false;
    };

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

      attic = {
        enable = true;

        user = "atticd";
        group = "atticd";

        settings = {
          listen = "[::]:8989";

          chunking = {
            nar-size-threshold = 64 * 1024;
            min-size = 16 * 1024;
            avg-size = 64 * 1024;
            max-size = 256 * 1024;
          };

          require-proof-of-possession = false;
        };
      };

      vault-agent = {
        enable = true;

        settings = {
          vault.address = "https://vault.quartz.hamho.me";
        };

        services = {
          atticd = {
            settings = {
              vault.address = "https://vault.quartz.hamho.me";

              auto_auth = {
                method = [{
                  type = "approle";

                  config = {
                    role_id_file_path = "/var/lib/vault-agent/attic/role-id";
                    secret_id_file_path = "/var/lib/vault-agent/attic/secret-id";

                    remove_secret_id_file_after_reading = false;
                  };
                }];
              };
            };

            secrets.environment.templates = {
              atticd-env = {
                text = ''
                  {{ with secret "secret/service/attic/atticd" }}
                  ATTIC_SERVER_TOKEN_HS256_SECRET_BASE64="{{ .Data.server_token }}"
                  {{ end }}
                '';
              };
            };
          };
        };
      };
    };

    security = {
      doas = enabled;
      acme = {
        enable = true;
      };
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

    certs."ruby.hamho.me" = {
      domain = "*.ruby.hamho.me";
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

            sslCertificate = "${config.security.acme.certs."ruby.hamho.me".directory}/fullchain.pem";
            sslCertificateKey = "${config.security.acme.certs."ruby.hamho.me".directory}/key.pem";
          };
        };
      in
      {
        "attic.ruby.hamho.me" =
          network.create-proxy
            ({
              port = 8989;
            }
            // shared-config);
      };
  };

  system.stateVersion = "22.05";
}
