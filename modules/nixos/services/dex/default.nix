{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (builtins) map removeAttrs;
  inherit (lib)
    mapAttrs
    flatten
    concatMap
    concatMapStringsSep
    ;

  cfg = config.${namespace}.services.dex;

  process-client-settings =
    client:
    if client ? secretFile then
      (removeAttrs client [ "secretFile" ]) // { secret = client.secretFile; }
    else
      client;

  settings =
    mapAttrs (name: value: if name == "staticClients" then map process-client-settings value else value)
      (
        cfg.settings
        // {
          storage = (cfg.settings.storage or { }) // {
            type = cfg.settings.storage.type or "sqlite3";
            config = cfg.settings.storage.config or { file = "${cfg.stateDir}/dex.db"; };
          };
        }
      );

  secret-files = concatMap (client: if client ? secretFile then [ client.secretFile ] else [ ]) (
    settings.staticClients or [ ]
  );

  format = pkgs.formats.yaml { };

  configYaml = format.generate "config.yaml" settings;

  replace-config-secrets = pkgs.writeShellScript "replace-config-secrets" (
    concatMapStringsSep "\n" (
      file: "${pkgs.replace-secret}/bin/replace-secret '${file}' '${file}' ${cfg.stateDir}/config.yaml"
    ) secret-files
  );
in
{
  options.${namespace}.services.dex = {
    enable = lib.mkEnableOption "Dex, the OpenID Connect and OAuth 2 identity provider";

    stateDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/dex";
      description = "The state directory where config and data are stored.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "dex";
      description = "The user to run Dex as.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "dex";
      description = "The group to run Dex as.";
    };

    settings = lib.mkOption {
      type = format.type;
      default = { };
      example = lib.literalExpression ''
        {
          # External url
          issuer = "http://127.0.0.1:5556/dex";
          storage = {
            type = "postgres";
            config.host = "/var/run/postgres";
          };
          web = {
            http = "127.0.0.1:5556";
          };
          enablePasswordDB = true;
          staticClients = [
            {
              id = "oidcclient";
              name = "Client";
              redirectURIs = [ "https://example.com/callback" ];

              # The content of `secretFile` will be written into to the config as `secret`.
              secretFile = "/etc/dex/oidcclient";
            }
          ];
        }
      '';
      description = lib.mdDoc ''
        The available options can be found in
        [the example configuration](https://github.com/dexidp/dex/blob/v${pkgs.dex.version}/config.yaml.dist).
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    users = {
      users = lib.optionalAttrs (cfg.user == "dex") {
        dex = {
          group = cfg.group;
          home = cfg.stateDir;
          isSystemUser = true;
        };
      };

      groups = lib.optionalAttrs (cfg.group == "dex") { dex = { }; };
    };

    systemd = {
      tmpfiles.rules = [ "d '${cfg.stateDir}' 0750 ${cfg.user} ${cfg.group}" ];

      services = {
        dex = {
          description = "dex identity provider";
          wantedBy = [ "multi-user.target" ];
          after = [ "networking.target" ];

          preStart = ''
            cp --remove-destination ${configYaml} ${cfg.stateDir}/config.yaml

            chmod 600 ${cfg.stateDir}/config.yaml

            ${replace-config-secrets}
          '';

          serviceConfig = {
            ExecStart = "${pkgs.dex-oidc}/bin/dex serve ${cfg.stateDir}/config.yaml";
            WorkingDirectory = cfg.stateDir;

            User = cfg.user;
            Group = cfg.group;

            AmbientCapabilities = "CAP_NET_BIND_SERVICE";
            BindReadOnlyPaths = [
              "/nix/store"
              "-/etc/resolv.conf"
              "-/etc/nsswitch.conf"
              "-/etc/hosts"
              "-/etc/localtime"
              "-/etc/dex"
            ];
            BindPaths = [
              cfg.stateDir
            ] ++ lib.optional (settings.storage.type == "postgres") "/var/run/postgresql";
            CapabilityBoundingSet = "CAP_NET_BIND_SERVICE";
            ## ProtectClock= adds DeviceAllow=char-rtc r
            #DeviceAllow = "";
            #DynamicUser = true;
            #LockPersonality = true;
            #MemoryDenyWriteExecute = true;
            #NoNewPrivileges = true;
            #PrivateDevices = true;
            #PrivateMounts = true;
            ## Port needs to be exposed to the host network
            ##PrivateNetwork = true;
            #PrivateTmp = true;
            #PrivateUsers = true;
            #ProcSubset = "pid";
            #ProtectClock = true;
            #ProtectHome = true;
            #ProtectHostname = true;
            ## Would re-mount paths ignored by temporary root
            ##ProtectSystem = "strict";
            #ProtectControlGroups = true;
            #ProtectKernelLogs = true;
            #ProtectKernelModules = true;
            #ProtectKernelTunables = true;
            #ProtectProc = "invisible";
            #RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
            #RestrictNamespaces = true;
            #RestrictRealtime = true;
            #RestrictSUIDSGID = true;
            #SystemCallArchitectures = "native";
            #SystemCallFilter = [ "@system-service" "~@privileged @resources @setuid @keyring" ];
            #TemporaryFileSystem = "/:ro";
            # Does not work well with the temporary root
            #UMask = "0066";
          };
        };
      };
    };
  };
}
