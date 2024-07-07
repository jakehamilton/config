# Huge thanks to @Zumorica for creating the initial module:
# https://github.com/Zumorica/GradientOS/blob/main/hosts/asiyah/palworld-server.nix
{
  config,
  pkgs,
  namespace,
  lib,
  ...
}:
let
  cfg = config.${namespace}.services.palworld;

  steam-id = "2394010";
  app-id = "1623730";

  palworld-server = lib.escapeShellArgs [
    "${pkgs.steam-run}/bin/steam-run"
    "/var/lib/steamcmd/apps/${steam-id}/PalServer.sh"
    "-publicport=${toString cfg.port}"
    "-useperfthreads"
    "-NoAsyncLoadingThread"
    "-UseMultithreadForDS"
    "EpicApp=PalServer"
  ];

  user-home = config.users.users.${cfg.user.name}.home;
  steamcmd-home = config.users.users.${cfg.steamcmd.name}.home;

  steamcmd-install-service = "steamcmd@${steam-id}.service";
in
{
  options.${namespace}.services.palworld = {
    enable = lib.mkEnableOption "Palworld server";

    autostart = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Automatically start the server.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8211;
      description = "The port to run the server on.";
    };

    user = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "palworld";
        description = "The user to run the server as";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "palworld";
        description = "The group to run the server as";
      };
    };

    steamcmd = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "steamcmd";
        description = "The user that runs steamcmd to install the game server.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "steamcmd";
        description = "The group that runs steamcmd to install the game server.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    plusultra.services.steam.enable = true;

    networking.firewall.allowedTCPPorts = [ cfg.port ];

    networking.firewall.allowedUDPPorts = [ cfg.port ];

    users = {
      users = lib.optionalAttrs (cfg.user.name == "palworld") {
        palworld = {
          isSystemUser = true;
          home = "/var/lib/palworld";
          createHome = true;
          homeMode = "750";
          group = cfg.user.group;

          extraGroups = [ cfg.steamcmd.group ];
        };
      };

      groups = lib.optionalAttrs (cfg.user.group == "palworld") { palworld = { }; };
    };

    systemd.tmpfiles.rules = [
      "d ${user-home}/.steam 0755 ${cfg.user.name} ${cfg.user.group} - -"
      "L+ ${user-home}/.steam/sdk64 - - - - ${steamcmd-home}/apps/1007/linux64"
    ];

    systemd.services.palworld = {
      path = [ pkgs.xdg-user-dirs ];

      # Manually start the server if needed, to save resources.
      wantedBy = lib.optional cfg.autostart "network-online.target";

      # Install the game before launching.
      wants = [ steamcmd-install-service ];
      after = [ steamcmd-install-service ];

      serviceConfig = {
        ExecStart = palworld-server;
        Nice = "-5";
        PrivateTmp = true;
        Restart = "on-failure";
        User = config.users.users.palworld.name;
        WorkingDirectory = "~";
      };

      environment = {
        SteamAppId = app-id;
      };
    };
  };
}
