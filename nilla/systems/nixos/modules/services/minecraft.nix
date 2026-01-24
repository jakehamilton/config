{ lib, config, ... }:

let
  cfg = config.plusultra.services.minecraft;

  server-submodule = { name, ... }: {
    options = {
      enable = lib.mkOption {
        description = "Whether to enable the Minecraft server.";
        type = lib.types.bool;
        default = true;
      };

      name = lib.mkOption {
        description = "The name of the Minecraft server.";
        type = lib.types.str;
        default = name;
      };

      port = lib.mkOption {
        description = "The port the Minecraft server will listen on.";
        type = lib.types.port;
        default = 25565;
      };

      user = lib.mkOption {
        description = "The user to run the Minecraft server as.";
        type = lib.types.str;
        default = "minecraft-${name}";
      };

      group = lib.mkOption {
        description = "The group to run the Minecraft server as.";
        type = lib.types.str;
        default = "minecraft-${name}";
      };

      dataDir = lib.mkOption {
        description = "The data directory for the Minecraft server.";
        type = lib.types.str;
        default = "/var/lib/minecraft-${name}";
      };

      version = lib.mkOption {
        description = "The Minecraft server (docker image) version to use.";
        type = lib.types.str;
        default = "latest";
      };

      container = lib.mkOption {
        description = "The name of the OCI container for the Minecraft server.";
        type = lib.types.str;
        default = "minecraft-${name}";
      };

      memory = lib.mkOption {
        description = "The amount of memory to allocate to the Minecraft server.";
        type = lib.types.str;
        default = "1G";
      };

      environment = lib.mkOption {
        description = "Additional environment variables for the Minecraft server container.";
        type = lib.types.attrsOf lib.types.str;
        default = { };
      };

      mods = {
        type = lib.mkOption {
          description = "The mod platform to use.";
          type = lib.types.nullOr (lib.types.enum [ "MODRINTH" ]);
          default = null;
        };

        file = lib.mkOption {
          description = "The modpack file to use (mutually exclusive with id).";
          type = lib.types.nullOr lib.types.path;
          default = null;
        };

        id = lib.mkOption {
          description = "The modpack ID to use (mutually exclusive with file).";
          type = lib.types.nullOr lib.types.str;
          default = null;
        };
      };
    };
  };

  servers = builtins.filter (server: server.enable) (builtins.attrValues cfg);
in
{
  options.plusultra.services.minecraft = lib.mkOption {
    description = "Minecraft server service configuration.";
    default = { };
    type = lib.types.attrsOf (lib.types.submodule server-submodule);
  };

  config = {
    systemd.tmpfiles.rules = builtins.map
      (server: "d ${server.dataDir} 0755 ${server.user} ${server.group} -")
      servers;

    networking.firewall = {
      allowedTCPPorts = builtins.map (server: server.port) servers;
      allowedUDPPorts = builtins.map (server: server.port) servers;
    };

    virtualisation.oci-containers.containers = builtins.foldl'
        (acc: server:
          if server.enable then
            acc // {
              "${server.container}" = {
                image = "itzg/minecraft-server:${server.version}";
                ports = [ "${builtins.toString server.port}:25565" ];
                volumes = [
                  "${server.dataDir}:/data"
                ] ++ lib.optional (server.mods.type == "MODRINTH" && server.mods.file != null) "${server.mods.file}:/mods.mrpack";
                environment = {
                  EULA = "TRUE";
                  TYPE = lib.mkIf (server.mods.type != null) server.mods.type;

                  MODRINTH_MODPACK = lib.mkIf (server.mods.type == "MODRINTH") (
                    if server.mods.file != null then "/mods.mrpack" else server.mods.id
                  );

                  MEMORY = server.memory;
                } // server.environment;
              };
            }
          else
            acc
        )
        {}
        servers;
  };
}
