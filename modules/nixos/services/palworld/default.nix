# Huge thanks to @Zumorica for creating the initial module:
# https://github.com/Zumorica/GradientOS/blob/main/hosts/asiyah/palworld-server.nix
{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.plusultra.services.palworld;
  steam-id = "2394010";
  port = 8211;
in {
  options.plusultra.services.palworld = {
    enable = lib.mkEnableOption "Palworld server";
  };

  config = lib.mkIf cfg.enable {
    plusultra.services.steam.enable = true;

    users.users.palworld = {
      isSystemUser = true;
      home = "/var/lib/palworld";
      createHome = true;
      homeMode = "750";
      group = config.users.groups.palworld.name;
    };

    users.groups.palworld = {};

    systemd.tmpfiles.rules = [
      "d ${config.users.users.palworld.home}/.steam 0755 ${config.users.users.palworld.name} ${config.users.groups.palworld.name} - -"
      "L+ ${config.users.users.palworld.home}/.steam/sdk64 - - - - /var/lib/steamcmd/apps/1007/linux64"
    ];

    systemd.services.palworld = {
      path = [pkgs.xdg-user-dirs];

      # Manually start the server if needed, to save resources.
      wantedBy = [];

      # Install the game before launching.
      wants = ["steamcmd@${steam-id}.service"];
      after = ["steamcmd@${steam-id}.service"];

      serviceConfig = {
        ExecStart = lib.escapeShellArgs [
          "${pkgs.steam-run}/bin/steam-run"
          "/var/lib/steamcmd/apps/${steam-id}/PalServer.sh"
          "-publicport=${toString port}"
          "-useperfthreads"
          "-NoAsyncLoadingThread"
          "-UseMultithreadForDS"
          "EpicApp=PalServer"
        ];
        Nice = "-5";
        PrivateTmp = true;
        Restart = "on-failure";
        User = config.users.users.palworld.name;
        WorkingDirectory = "~";
      };
      environment = {
        SteamAppId = "1623730";
      };
    };

    networking.firewall.allowedTCPPorts = [
      port
    ];

    networking.firewall.allowedUDPPorts = [
      port
    ];
  };
}
