{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.services.palworld-container;
in
{
  options.${namespace}.services.palworld-container = {
    enable = lib.mkEnableOption "Palworld (Docker)";

    stateDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/palworld";
      description = "Directory where Palworld stores its state.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "palworld";
      description = "User that runs Palworld.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "palworld";
      description = "Group that runs Palworld.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8211;
      description = "The port to expose Palworld on.";
    };

    players = lib.mkOption {
      type = lib.types.int;
      default = 32;
      description = "The number of players to allow on the server.";
    };

    update = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to update the server on startup.";
    };
  };

  config = lib.mkIf cfg.enable {
    users = {
      users = lib.optionalAttrs (cfg.user == "palworld") {
        palworld = {
          group = cfg.group;
          home = cfg.stateDir;
          isSystemUser = true;
        };
      };

      groups = lib.optionalAttrs (cfg.group == "palworld") { palworld = { }; };
    };

    systemd.tmpfiles.rules = [ "d ${cfg.stateDir} 0750 ${cfg.user} ${cfg.group} -" ];

    virtualisation.oci-containers.containers.palworld = {
      image = "jammsen/palworld-dedicated-server:latest";

      user = cfg.user;

      environment = {
        GAME_PORT = builtins.toString cfg.port;
        MAX_PLAYERS = builtins.toString cfg.players;
        MULTITHREAD_ENABLED = "true";

        ALWAYS_UPDATE_ON_START = if cfg.update then "true" else "false";

        COMMUNITY_SERVER = "false";
        PUBLIC_IP = "";
        PUBLIC_PORT = "";
      };

      ports = [ "${builtins.toString cfg.port}:${builtins.toString cfg.port}" ];

      volumes = [ "${cfg.stateDir}:/palworld" ];
    };
  };
}
