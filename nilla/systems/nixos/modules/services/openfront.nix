{ lib, config, pkgs, project, ... }:

let
  cfg = config.plusultra.services.openfront;
in
{
  options.plusultra.services.openfront = {
    enable = lib.mkEnableOption "OpenFront";

    package = lib.mkOption {
      type = lib.types.package;
      default = project.inputs.openfrontio.result.packages.openfront.result.${pkgs.system};
      description = "The package to use for the OpenFront server.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 3000;
      description = "The base port for the OpenFront server (workers will use ports starting above this one).";
    };

    stateDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/openfront";
      description = "The directory where the OpenFront server state will be stored.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "openfront";
      description = "The user to run the OpenFront server as.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "openfront";
      description = "The group to run the OpenFront server as.";
    };

    host = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "The domain to serve the OpenFront server at.";
    };

    nginx = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to enable Nginx for the OpenFront server.";
      };

      forceSSL = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to force SSL for the OpenFront server.";
      };
    };

    acme = {
      enable = lib.mkEnableOption "ACME for OpenFront";
    };

    environmentFile = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = ''
        The environment file to use for the OpenFront server. This file must contain the following
        environment variables:

        ```shell
        # Admin credentials
        ADMIN_TOKEN=your_admin_token_here

        # Cloudflare Configuration
        CF_ACCOUNT_ID=your_cloudflare_account_id
        CF_API_TOKEN=your_cloudflare_api_token

        # R2 Configuration
        R2_ACCESS_KEY=your_r2_access_key
        R2_SECRET_KEY=your_r2_secret_key
        R2_BUCKET=your-bucket-name
        ```
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.host != "";
        message = "The host domain must be set for the OpenFront server.";
      }

      {
        assertion = cfg.environmentFile != "";
        message = "The environment file must be set for the OpenFront server.";
      }
    ];

    users = {
      users = lib.optionalAttrs (cfg.user == "openfront") {
        openfront = {
          group = cfg.group;
          home = cfg.stateDir;
          isSystemUser = true;
        };
      };

      groups = lib.optionalAttrs (cfg.user == "openfront") {
        openfront = { };
      };
    };

    systemd.tmpfiles.settings = {
      "10-openfront".${cfg.stateDir}.d = {
        inherit (cfg) user group;
        mode = "0750";
      };
    };

    systemd.services.openfront = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      description = "OpenFront Game Server";

      environment = {
        GAME_ENV = "prod";
        NODE_PORT = builtins.toString cfg.port;
        DOMAIN = cfg.host;
        VERSION_TAG = "latest";
        CF_CREDS_PATH = "${cfg.stateDir}/creds.json";
        CF_CONFIG_PATH = "${cfg.stateDir}/config.json";
      };

      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = 5;

        EnvironmentFile = cfg.environmentFile;

        ExecStart = "${cfg.package}/bin/openfront";
      };
    };

    services.nginx = lib.mkIf cfg.nginx.enable {
      enable = true;
      recommendedProxySettings = true;

      proxyCachePath = {
        STATIC = {
          enable = true;
          keysZoneName = "STATIC";
        };
        API_CACHE = {
          enable = true;
          keysZoneName = "API_CACHE";
        };
      };

      virtualHosts.${cfg.host} = {
        locations = {
          "/" = {
            proxyWebsockets = true;
            proxyPass = "http://127.0.0.1:${builtins.toString cfg.port}";

            extraConfig = ''
              # Tell browsers not to cache
              add_header Cache-Control "no-store, no-cache, must-revalidate, proxy-revalidate";
              add_header Pragma "no-cache";
              add_header Expires "0";

              # But let Nginx cache for 1 second to reduce load
              proxy_cache STATIC;
              proxy_cache_valid 200 302 1s;
              proxy_cache_use_stale error timeout updating http_500 http_502 http_503 http_504;
              proxy_cache_lock on;

              # Show cache status in response headers
              add_header X-Cache-Status $upstream_cache_status;
            '';
          };

          "~* ^/w(\\d+)(/.*)?$" = {
            proxyWebsockets = true;

            extraConfig = ''
              set $worker $1;
              set $worker_port ${builtins.toString (cfg.port + 1)};

              if ($worker = "0") { set $worker_port ${builtins.toString (cfg.port + 1)}; }
              if ($worker = "1") { set $worker_port ${builtins.toString (cfg.port + 2)}; }
              if ($worker = "2") { set $worker_port ${builtins.toString (cfg.port + 3)}; }
              if ($worker = "3") { set $worker_port ${builtins.toString (cfg.port + 4)}; }
              if ($worker = "4") { set $worker_port ${builtins.toString (cfg.port + 5)}; }
              if ($worker = "5") { set $worker_port ${builtins.toString (cfg.port + 6)}; }
              if ($worker = "6") { set $worker_port ${builtins.toString (cfg.port + 7)}; }
              if ($worker = "7") { set $worker_port ${builtins.toString (cfg.port + 8)}; }
              if ($worker = "8") { set $worker_port ${builtins.toString (cfg.port + 9)}; }
              if ($worker = "9") { set $worker_port ${builtins.toString (cfg.port + 10)}; }
              if ($worker = "10") { set $worker_port ${builtins.toString (cfg.port + 11)}; }
              if ($worker = "11") { set $worker_port ${builtins.toString (cfg.port + 12)}; }
              if ($worker = "12") { set $worker_port ${builtins.toString (cfg.port + 13)}; }
              if ($worker = "13") { set $worker_port ${builtins.toString (cfg.port + 14)}; }
              if ($worker = "14") { set $worker_port ${builtins.toString (cfg.port + 15)}; }
              if ($worker = "15") { set $worker_port ${builtins.toString (cfg.port + 16)}; }
              if ($worker = "16") { set $worker_port ${builtins.toString (cfg.port + 17)}; }
              if ($worker = "17") { set $worker_port ${builtins.toString (cfg.port + 18)}; }
              if ($worker = "18") { set $worker_port ${builtins.toString (cfg.port + 19)}; }
              if ($worker = "19") { set $worker_port ${builtins.toString (cfg.port + 20)}; }
              if ($worker = "20") { set $worker_port ${builtins.toString (cfg.port + 21)}; }
              if ($worker = "21") { set $worker_port ${builtins.toString (cfg.port + 22)}; }
              if ($worker = "22") { set $worker_port ${builtins.toString (cfg.port + 23)}; }
              if ($worker = "23") { set $worker_port ${builtins.toString (cfg.port + 24)}; }
              if ($worker = "24") { set $worker_port ${builtins.toString (cfg.port + 25)}; }
              if ($worker = "25") { set $worker_port ${builtins.toString (cfg.port + 26)}; }
              if ($worker = "26") { set $worker_port ${builtins.toString (cfg.port + 27)}; }
              if ($worker = "27") { set $worker_port ${builtins.toString (cfg.port + 28)}; }
              if ($worker = "28") { set $worker_port ${builtins.toString (cfg.port + 29)}; }
              if ($worker = "29") { set $worker_port ${builtins.toString (cfg.port + 30)}; }
              if ($worker = "30") { set $worker_port ${builtins.toString (cfg.port + 31)}; }
              if ($worker = "31") { set $worker_port ${builtins.toString (cfg.port + 32)}; }
              if ($worker = "32") { set $worker_port ${builtins.toString (cfg.port + 33)}; }
              if ($worker = "33") { set $worker_port ${builtins.toString (cfg.port + 34)}; }
              if ($worker = "34") { set $worker_port ${builtins.toString (cfg.port + 35)}; }
              if ($worker = "35") { set $worker_port ${builtins.toString (cfg.port + 36)}; }
              if ($worker = "36") { set $worker_port ${builtins.toString (cfg.port + 37)}; }
              if ($worker = "37") { set $worker_port ${builtins.toString (cfg.port + 38)}; }
              if ($worker = "38") { set $worker_port ${builtins.toString (cfg.port + 39)}; }
              if ($worker = "39") { set $worker_port ${builtins.toString (cfg.port + 40)}; }
              if ($worker = "40") { set $worker_port ${builtins.toString (cfg.port + 41)}; }

              proxy_pass http://127.0.0.1:$worker_port$2;
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection $connection_upgrade;
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
            '';
          };

          # /api/public_lobbies endpoint - Cache for 1 second to handle high request volume
          "/api/public_lobbies" = {
            proxyPass = "http://127.0.0.1:${builtins.toString cfg.port}";

            extraConfig = ''
              # Cache configuration
              proxy_cache API_CACHE;
              proxy_cache_valid 200 1s;
              proxy_cache_use_stale updating error timeout http_500 http_502 http_503 http_504;
              proxy_cache_lock on;
              add_header X-Cache-Status $upstream_cache_status;

              # Standard proxy headers
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
            '';
          };

          # /api/env endpoint - Cache for 1 hour
          "/api/env" = {
            proxyPass = "http://127.0.0.1:${builtins.toString cfg.port}";

            extraConfig = ''
              # Cache configuration
              proxy_cache API_CACHE;
              proxy_cache_valid 200 1h;  # Cache successful responses for 1 hour
              proxy_cache_use_stale error timeout http_500 http_502 http_503 http_504;
              proxy_cache_lock on;
              add_header X-Cache-Status $upstream_cache_status;

              # Standard proxy headers
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
            '';
          };

          "~* \\.(jpg|jpeg|png|gif|ico|svg|webp|woff|woff2|ttf|eot)$" = {
            proxyPass = "http://127.0.0.1:${builtins.toString cfg.port}";

            extraConfig = ''
              # Cache configuration for static files
              proxy_cache STATIC;
              proxy_cache_valid 200 302 24h;  # Cache successful responses for 24 hours
              proxy_cache_use_stale error timeout updating http_500 http_502 http_503 http_504;
              proxy_cache_lock on;

              # Show cache status in response headers
              add_header X-Cache-Status $upstream_cache_status;

              # Standard proxy headers
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;

              # Default cache policy for static files
              add_header Cache-Control "public, max-age=86400";  # 24 hours

            '';
          };


          "~* \\.(bin|dat|exe|dll|so|dylib)$" = {
            proxyPass = "http://127.0.0.1:${builtins.toString cfg.port}";

            extraConfig = ''
              add_header Cache-Control "public, max-age=31536000, immutable";  # 1 year for binary files

              proxy_cache STATIC;
              proxy_cache_valid 200 302 24h;
              proxy_cache_use_stale error timeout updating http_500 http_502 http_503 http_504;
              proxy_cache_lock on;
              add_header X-Cache-Status $upstream_cache_status;

              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
            '';
          };

          "~* \\.js$" = {
            proxyPass = "http://127.0.0.1:${builtins.toString cfg.port}";
            extraConfig = ''
              add_header Content-Type application/javascript;
              add_header Cache-Control "public, max-age=31536000, immutable";  # 1 year for JS files

              proxy_cache STATIC;
              proxy_cache_valid 200 302 24h;
              proxy_cache_use_stale error timeout updating http_500 http_502 http_503 http_504;
              proxy_cache_lock on;
              add_header X-Cache-Status $upstream_cache_status;

              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
            '';
          };

          "~* \\.css$" = {
            proxyPass = "http://127.0.0.1:${builtins.toString cfg.port}";
            extraConfig = ''
              add_header Content-Type text/css;
              add_header Cache-Control "public, max-age=31536000, immutable";  # 1 year for CSS files

              proxy_cache STATIC;
              proxy_cache_valid 200 302 24h;
              proxy_cache_use_stale error timeout updating http_500 http_502 http_503 http_504;
              proxy_cache_lock on;
              add_header X-Cache-Status $upstream_cache_status;

              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
            '';
          };

          "~* \\.html$" = {
            proxyPass = "http://127.0.0.1:${builtins.toString cfg.port}";
            extraConfig = ''
              add_header Content-Type text/html;
              add_header Cache-Control "public, max-age=1";  # 1 second for HTML files

              proxy_cache STATIC;
              proxy_cache_valid 200 302 1s;  # Cache successful responses for 1 second
              proxy_cache_use_stale error timeout updating http_500 http_502 http_503 http_504;
              proxy_cache_lock on;
              add_header X-Cache-Status $upstream_cache_status;

              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
            '';
          };
        };
      };
    };
  };
}
