{
  config,
  options,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) types;

  cfg = config.${namespace}.services.minecraft;
in
{
  options.${namespace}.services.minecraft = {
    enable = lib.mkEnableOption "Minecraft server";

    eula = lib.mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether you agree to
        [Mojang's EULA](https://account.mojang.com/documents/minecraft_eula).
        This option must be set to `true` to run Minecraft server.
      '';
    };

    infrared = {
      enable = lib.mkEnableOption "Infrared";
    };

    servers = lib.mkOption {
      default = { };
      description = "The Minecraft servers to run.";
      example = lib.literalExpression ''
        {
          # A default vanilla server.
          vanilla-1 = {};

          # A vanilla server with a custom port.
          vanilla-2 = {
            port = 4000;
          };

          # A vanilla server proxied by Infrared (when enabled).
          vanilla-3 = {
            domain = "minecraft.example.com";
          };

          # A Forge server.
          forge-1 = {
            type = "forge";
          };

          # Use a custom Minecraft server version.
          custom-vanilla = {
            package = pkgs.minecraft-server_1_12_2;
          };

          # Use a custom Forge server version.
          custom-forge = {
            type = "forge";
            package = pkgs.minecraft-forge_1_19_2-43_1_25;
          };
        }
      '';

      type = types.attrsOf (
        types.submodule (
          { config, name, ... }:
          {
            options = {
              type = lib.mkOption {
                type = types.enum [
                  "vanilla"
                  "forge"
                ];
                default = "vanilla";
                description = "The kind of Minecraft server to create.";
              };

              package = lib.mkOption {
                type = types.package;
                default =
                  if config.type == "vanilla" then pkgs.minecraft-server else pkgs.plusultra.minecraft-forge;
                defaultText = lib.literalExpression ''
                  pkgs.minecraft-server
                '';
              };

              dataDir = lib.mkOption {
                type = types.path;
                default = "/var/lib/minecraft/${name}";
                defaultText = "/var/lib/minecraft/<name>";
                description = "The datrectory where data for the server is stored.";
              };

              port = lib.mkOption {
                type = types.port;
                default = 25565;
                description = "The port for the server to listen on.";
              };

              domain = lib.mkOption {
                type = types.str;
                default = "";
                description = "The domain to pass to Infrared (if enabled).";
              };

              jvmOpts = lib.mkOption {
                type = types.separatedString " ";
                default = "-Xmx2048M -Xms2048M";
                # Example options from https://minecraft.gamepedia.com/Tutorials/Server_startup_script
                example =
                  "-Xms4092M -Xmx4092M -XX:+UseG1GC -XX:+CMSIncrementalPacing "
                  + "-XX:+CMSClassUnloadingEnabled -XX:ParallelGCThreads=2 "
                  + "-XX:MinHeapFreeRatio=5 -XX:MaxHeapFreeRatio=10";
                description = lib.mdDoc "JVM options for the Minecraft server.";
              };

              serverProperties = lib.mkOption {
                type = types.attrsOf (
                  types.oneOf [
                    types.bool
                    types.int
                    types.str
                  ]
                );
                default = { };
                example = lib.literalExpression ''
                  {
                    server-port = 43000;
                    difficulty = 3;
                    gamemode = 1;
                    max-players = 5;
                    motd = "NixOS Minecraft server!";
                    white-list = true;
                    enable-rcon = true;
                    "rcon.password" = "hunter2";
                  }
                '';
                description = lib.mdDoc ''
                  Minecraft server properties for the server.properties file. Only has
                  an effect when {option}`services.minecraft-server.declarative`
                  is set to `true`. See
                  <https://minecraft.gamepedia.com/Server.properties#Java_Edition_3>
                  for documentation on these values.
                '';
              };

              whitelist = lib.mkOption {
                type =
                  let
                    minecraftUUID =
                      lib.types.strMatching "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}"
                      // {
                        description = "Minecraft UUID";
                      };
                  in
                  lib.types.attrsOf minecraftUUID;
                default = { };
                description = lib.mdDoc ''
                  Whitelisted players, only has an effect when
                  {option}`services.minecraft-server.declarative` is
                  `true` and the whitelist is enabled
                  via {option}`services.minecraft-server.serverProperties` by
                  setting `white-list` to `true`.
                  This is a mapping from Minecraft usernames to UUIDs.
                  You can use <https://mcuuid.net/> to get a
                  Minecraft UUID for a username.
                '';
                example = lib.literalExpression ''
                  {
                    username1 = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx";
                    username2 = "yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy";
                  };
                '';
              };

              openFirewall = lib.mkOption {
                type = types.bool;
                default = false;
                description = lib.mdDoc ''
                  Whether to open ports in the firewall for the server.
                '';
              };

              declarative = lib.mkOption {
                type = types.bool;
                default = false;
                description = lib.mdDoc ''
                  Whether to use a declarative Minecraft server configuration.
                  Only if set to `true`, the options
                  {option}`plusultra.services.minecraft.servers.<name>.whitelist` and
                  {option}`plusultra.services.minecraft.servers.<name>.serverProperties` will be
                  applied.
                '';
              };

              extraInfraredOptions = lib.mkOption {
                type = types.attrs;
                default = { };

                description = lib.mdDoc ''
                  Extra options passed to Infrared (if enabled) when configuring this server.
                '';
              };
            };
          }
        )
      );
    };
  };
}
