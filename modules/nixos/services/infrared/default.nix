{
  config,
  options,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (builtins) toString;
  inherit (lib) types;

  cfg = config.${namespace}.services.infrared;

  format = pkgs.formats.json { };

  serversType = types.submodule (
    { config, ... }:
    {
      options = {
        domain = lib.mkOption {
          type = types.str;
          default = "";
          description = ''
            The domain to proxy. Should be fully qualified domain name.
            Note: Every string is accepted. So localhost is also valid.
          '';
          example = "minecraft.example.com";
        };

        host = lib.mkOption {
          type = types.str;
          default = "";
          description = "The host where the Minecraft server is running. Defaults to local host.";
        };

        port = lib.mkOption {
          type = types.port;
          default = 25566;
          description = "The port where the Minecraft server is running.";
        };

        settings = lib.mkOption {
          default = { };
          description = ''
            Infrared configuration (<filename>config.json</filename>). Refer to
            <link xlink:href="https://github.com/haveachin/infrared#proxy-config" />
            for details.
          '';

          type = types.submodule {
            freeformType = format.type;

            options = {
              domainName = lib.mkOption {
                type = types.str;
                default = config.domain;
                defaultText = lib.literalExpression ''
                  ""
                '';
                description = "The domain to proxy.";
              };

              proxyTo = lib.mkOption {
                type = types.str;
                default = "${config.host}:${toString config.port}";
                defaultText = ":25565";
                description = "The address that the proxy should send incoming connections to.";
              };
            };
          };
        };
      };
    }
  );
in
{
  options.${namespace}.services.infrared = {
    enable = lib.mkEnableOption "Infrared";

    stateDir = lib.mkOption {
      type = types.path;
      default = "/var/lib/infrared";
      description = "The state directory where configurations are stored.";
    };

    user = lib.mkOption {
      type = types.str;
      default = "infrared";
      description = "User under which Infrared is ran.";
    };

    group = lib.mkOption {
      type = types.str;
      default = "infrared";
      description = "Group under which Infrared is ran.";
    };

    openFirewall = lib.mkOption {
      type = types.bool;
      default = false;
      description = "Whether to open the firewall for ports specified by each server's listenTo address.";
    };

    servers = lib.mkOption {
      type = types.listOf serversType;
      default = [ ];
      description = "The servers to proxy.";
      example = lib.literalExpression ''
        [
          {
            domain = "minecraft.example.com";
            port = 25567;
          }
        ]
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [ ];

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedUDPPorts = builtins.map (server: server.port) cfg.servers;
      allowedTCPPorts = builtins.map (server: server.port) cfg.servers;
    };

    systemd.tmpfiles.rules =
      [ "d '${cfg.stateDir}' 0750 ${cfg.user} ${cfg.group} - -" ]
      ++ builtins.map (
        server:
        let
          config = format.generate "${server.domain}.json" server.settings;
        in
        "L+ '${cfg.stateDir}/${server.domain}.json' - - - - ${config}"
      ) cfg.servers;

    systemd.services.infrared = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.stateDir;
        ExecStart = "${pkgs.plusultra.infrared}/bin/infrared -config-path ${cfg.stateDir}";
      };
    };

    users = {
      users = lib.optionalAttrs (cfg.user == "infrared") {
        infrared = {
          group = cfg.group;
          home = "/var/lib/infrared";
          isSystemUser = true;
        };
      };

      groups = lib.optionalAttrs (cfg.group == "infrared") { infrared = { }; };
    };
  };
}
