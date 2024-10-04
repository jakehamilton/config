{ lib, pkgs, config, ... }:

let
  cfg = config.plusultra.services.plane;

	protocol = if cfg.acme.enable then "https" else "http";
	url = "${protocol}://${cfg.domain}";

  environment = {
		RUNTIME_DIR = cfg.stateDir;

    DEBUG = "1";

    WEB_URL = url;

    GUNICORN_WORKERS = builtins.toString cfg.api.workers;

    DATABASE_URL = "postgresql://${cfg.database.user}:${cfg.database.password}@${cfg.database.host}:${toString cfg.database.port}/${cfg.database.name}";
    REDIS_URL = "redis://${cfg.cache.host}:${toString cfg.cache.port}";

    USE_MINIO = if cfg.storage.local then "1" else "0";
    AWS_REGION = cfg.storage.region;
    AWS_ACCESS_KEY_ID = cfg.storage.accessKey;
    AWS_SECRET_ACCESS_KEY = cfg.storage.secretKey;
    AWS_S3_ENDPOINT_URL = "${cfg.storage.protocol}://${cfg.storage.host}:${toString cfg.storage.port}";
    AWS_S3_BUCKET_NAME = cfg.storage.bucket;

    APP_BASE_URL = "${url}/api";
    ADMIN_BASE_URL = "${url}/god-mode";
    SPACE_BASE_URL = "${url}/space";

    NEXT_PUBLIC_API_BASE_URL = "${url}/api";

    PYTHONPATH = "${cfg.package.apiserver}/${cfg.package.apiserver.python.sitePackages}";

		SECRET_KEY = cfg.secretKey;
		CORS_ALLOWED_ORIGINS = "http://${cfg.domain},http://127.0.0.1,http://localhost,https://${cfg.domain},https://127.0.0.1,https://localhost";
		COOKIE_DOMAIN = cfg.domain;
  };
in
{
  options.plusultra.services.plane = {
    enable = lib.mkEnableOption "Plane";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.plane;
      description = "The Plane package to use.";
    };

    domain = lib.mkOption {
      type = lib.types.str;
      description = "The domain to use for hosting Plane.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "plane";
      description = "The user to use for the Plane service.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "plane";
      description = "The group to use for the Plane service.";
    };

    stateDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/plane";
      description = "The state directory for the Plane service.";
    };

		secretKey = lib.mkOption {
			type = lib.types.str;
			default = "CHANGEME";
			description = "The secret key to use for the Plane service.";
		};

    web = {
      port = lib.mkOption {
        type = lib.types.port;
        default = 3101;
        description = "The port to use for the Plane web service.";
      };
    };

    admin = {
      port = lib.mkOption {
        type = lib.types.port;
        default = 3102;
        description = "The port to use for the Plane admin service.";
      };
    };

    api = {
      workers = lib.mkOption {
        type = lib.types.int;
        default = 1;
        description = "The number of workers to use for the Plane api service.";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 3103;
        description = "The port to use for the Plane api service.";
      };
    };

    space = {
      port = lib.mkOption {
        type = lib.types.port;
        default = 3104;
        description = "The port to use for the Plane space service.";
      };
    };

    database = {
      local = lib.mkEnableOption "local Plane PostgreSQL database";

      user = lib.mkOption {
        type = lib.types.str;
        default = "plane";
        description = "The user to use for the Plane database.";
      };

      # FIXME: This should be `passwordFile` and read during runtime rather than
      # being a raw, unencrypted value at eval time.
      password = lib.mkOption {
        type = lib.types.str;
        default = "CHANGEME";
        description = "The password to use for the Plane database.";
      };

      name = lib.mkOption {
        type = lib.types.str;
        default = "plane";
        description = "The name of the Plane database.";
      };

      host = lib.mkOption {
        type = lib.types.str;
        default = "localhost";
        description = "The host of the Plane database.";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 5432;
        description = "The port of the Plane database.";
      };
    };

    storage = {
      local = lib.mkEnableOption "local MinIO instance";

      region = lib.mkOption {
        type = lib.types.str;
        default = "us-east-1";
        description = "The region to use for the Plane storage.";
      };

      accessKey = lib.mkOption {
        type = lib.types.str;
        default = "CHANGEME";
        description = "The access key to use for the Plane storage.";
      };

      secretKey = lib.mkOption {
        type = lib.types.str;
        default = "CHANGEME";
        description = "The secret key to use for the Plane storage.";
      };

      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "The host of the Plane storage.";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 9000;
        description = "The port of the Plane storage.";
      };

      bucket = lib.mkOption {
        type = lib.types.str;
        default = "uploads";
        description = "The bucket to use for the Plane storage.";
      };

      protocol = lib.mkOption {
        type = lib.types.enum [ "http" "https" ];
        default = "http";
        description = "The protocol to use for the Plane storage.";
      };
    };

    cache = {
      local = lib.mkEnableOption "local Redis instance";

      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "The host of the Plane cache.";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 6379;
        description = "The port of the Plane cache.";
      };
    };

    acme = {
      enable = lib.mkEnableOption "ACME for Plane";
    };
  };

  config = lib.mkIf cfg.enable {
    users = {
      users = lib.optionalAttrs (cfg.user == "plane") {
        plane = {
          group = cfg.group;
          home = cfg.stateDir;
          isSystemUser = true;
        };
      };

      groups = lib.optionalAttrs (cfg.group == "plane") {
        plane = { };
      };
    };

    systemd = {
      tmpfiles.rules = [
        "d '${cfg.stateDir}' 0750 ${cfg.user} ${cfg.group} - -"
      ];

      services = {
        plane-web = {
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];

          environment = environment // {
						PORT = builtins.toString cfg.web.port;
					};

          serviceConfig = {
            User = cfg.user;
            Group = cfg.group;
            ExecStart = "${cfg.package}/bin/web";
            WorkingDirectory = cfg.stateDir;
          };
        };

        plane-admin = {
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];

          environment = environment // {
						PORT = builtins.toString cfg.admin.port;
					};

          serviceConfig = {
            User = cfg.user;
            Group = cfg.group;
            ExecStart = "${cfg.package}/bin/admin";
            WorkingDirectory = cfg.stateDir;
          };
        };

        plane-space = {
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];

          environment = environment // {
						PORT = builtins.toString cfg.space.port;
					};

          serviceConfig = {
            User = cfg.user;
            Group = cfg.group;
            ExecStart = "${cfg.package}/bin/space";
            WorkingDirectory = cfg.stateDir;
          };
        };

        plane-beat = {
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];

          inherit environment;

          serviceConfig = {
            Type = "simple";
            User = cfg.user;
            Group = cfg.group;
            WorkingDirectory = cfg.stateDir;
          };

          script = ''
						${cfg.package}/bin/apiserver wait_for_db
						${cfg.package}/bin/apiserver wait_for_migrations

						exec ${cfg.package.apiserver.interpreter} -m celery \
							--app plane
							--workdir ${cfg.package.src}/apiserver \
							beat -l info
					'';
        };

        plane-worker = {
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];

          inherit environment;

          serviceConfig = {
            Type = "simple";
            User = cfg.user;
            Group = cfg.group;
            WorkingDirectory = cfg.stateDir;
          };

          script = ''
						${cfg.package}/bin/apiserver wait_for_db
						${cfg.package}/bin/apiserver wait_for_migrations

						exec ${cfg.package.apiserver.interpreter} -m celery \
							--app plane
							--workdir ${cfg.package.src}/apiserver \
							worker -l info
					'';
        };

				plane-db-init = {
          wantedBy = [ "multi-user.target" ];
					requires = [ "postgresql.service" ];
					requiredBy = [ "plane-migrate.service" ];
          after = [ "postgresql.service" ];

					serviceConfig = {
						Type = "oneshot";
						User = cfg.user;
						Group = cfg.group;
						WorkingDirectory = cfg.stateDir;
					};

					script = ''
						${config.services.postgresql.package}/bin/psql -h /var/run/postgresql --command "ALTER USER ${cfg.database.user} WITH PASSWORD '${cfg.database.password}'"
					'';
				};

				plane-migrate = {
          wantedBy = [ "multi-user.target" ];
					requiredBy = [
						"plane-web.service"
						"plane-admin.service"
						"plane-space.service"
						"plane-beat.service"
						"plane-worker.service"
						"plane-api.service"
					];
          after = [ "network.target" ];
					before = [
						"plane-web.service"
						"plane-admin.service"
						"plane-space.service"
						"plane-beat.service"
						"plane-worker.service"
						"plane-api.service"
					];

          inherit environment;

          serviceConfig = {
            Type = "oneshot";
            User = cfg.user;
            Group = cfg.group;
            WorkingDirectory = cfg.stateDir;
          };

          script = ''
						${cfg.package}/bin/apiserver wait_for_db
						${cfg.package}/bin/apiserver migrate
					'';
				};

        plane-api = {
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];

					path = with pkgs; [
						nettools
						iproute2
						procps
						coreutils-full
						gawk
					];

          inherit environment;

          serviceConfig = {
            Type = "simple";
            User = cfg.user;
            Group = cfg.group;
            WorkingDirectory = cfg.stateDir;
          };

          script = ''
						${cfg.package}/bin/apiserver wait_for_db
						${cfg.package}/bin/apiserver wait_for_migrations

						# Collect system information
						HOSTNAME=$(hostname)
						MAC_ADDRESS=$(ip link show | awk '/ether/ {print $2}' | head -n 1)
						CPU_INFO=$(cat /proc/cpuinfo)
						MEMORY_INFO=$(free -h)
						DISK_INFO=$(df -h)

						# Concatenate information and compute SHA-256 hash
						SIGNATURE=$(echo "$HOSTNAME$MAC_ADDRESS$CPU_INFO$MEMORY_INFO$DISK_INFO" | sha256sum | awk '{print $1}')

						# Export the variables
						export MACHINE_SIGNATURE=$SIGNATURE

						${cfg.package}/bin/apiserver register_instance "$MACHINE_SIGNATURE"
						${cfg.package}/bin/apiserver configure_instance

						${cfg.package}/bin/apiserver create_bucket
						${cfg.package}/bin/apiserver clear_cache

						exec ${cfg.package.apiserver.interpreter} -m gunicorn \
							--name gunicorn-plane-api \
							--chdir ${cfg.package.src}/apiserver \
							--pythonpath ${cfg.package.apiserver}/${cfg.package.apiserver.python.sitePackages} \
							--bind "0.0.0.0:${builtins.toString cfg.api.port}" \
							--workers ${builtins.toString cfg.api.workers} \
							--worker-class uvicorn.workers.UvicornWorker \
							--max-requests 1200 \
							--max-requests-jitter 1000 \
							--access-logfile - \
							plane.asgi:application
					'';
        };
      };
    };

    services = {
      nginx = {
        enable = true;
        recommendedProxySettings = true;

        virtualHosts.${cfg.domain} = {
          enableACME = cfg.acme.enable;
          forceSSL = cfg.acme.enable;
          locations = {
            "/" = {
              proxyPass = "http://127.0.0.1:${builtins.toString cfg.web.port}";
              proxyWebsockets = true;
            };

            "/god-mode/" = {
              proxyPass = "http://127.0.0.1:${builtins.toString cfg.admin.port}";
              proxyWebsockets = true;
            };

            "/space/" = {
              proxyPass = "http://127.0.0.1:${builtins.toString cfg.space.port}";
              proxyWebsockets = true;
            };

            "/api/" = {
              proxyPass = "http://127.0.0.1:${builtins.toString cfg.api.port}/";
              proxyWebsockets = true;
            };

            "/${cfg.storage.bucket}/" = {
              proxyPass = "${builtins.toString cfg.storage.protocol}://${builtins.toString cfg.storage.host}:${toString cfg.storage.port}";
              proxyWebsockets = true;
            };
          };
        };
      };

      postgresql = lib.mkIf cfg.database.local {
        enable = true;

        ensureUsers = [{
          name = cfg.database.user;
          ensureDBOwnership = true;
					ensureClauses.login = true;
        }];

        ensureDatabases = [
          cfg.database.name
        ];
      };

      minio = lib.mkIf cfg.storage.local {
        enable = true;
        accessKey = cfg.storage.accessKey;
        secretKey = cfg.storage.secretKey;
        listenAddress = ":${toString cfg.storage.port}";
      };

      redis = lib.mkIf cfg.cache.local {
        servers.plane = {
          enable = true;
          port = cfg.cache.port;
        };
      };
    };
  };
}
