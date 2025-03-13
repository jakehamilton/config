{ lib, config, pkgs, project, ... }:
let
  cfg = config.plusultra.services.websites.retrospectacle;
in
{
  options.plusultra.services.websites.retrospectacle = {
    enable = lib.mkEnableOption "Lasers and Feelings Website";

    package = lib.mkOption {
      description = "The site package to use.";
      type = lib.types.package;
      default = project.inputs.retrospectacle-website.loaded.packages.${pkgs.system}.default;
    };

    domain = lib.mkOption {
      description = "The domain to serve the website on.";
      type = lib.types.str;
      default = "retrospectacle.app";
    };

    acme.enable = lib.mkOption {
      description = "Whether to automatically fetch and configure SSL certs.";
      type = lib.types.bool;
      default = true;
    };

    user = lib.mkOption {
      description = "The user to run the website as.";
      type = lib.types.str;
      default = "retrospectacle";
    };

    group = lib.mkOption {
      description = "The group to run the website as.";
      type = lib.types.str;
      default = "retrospectacle";
    };

    port = lib.mkOption {
      description = "The port to run the website on.";
      type = lib.types.port;
      default = 6901;
    };
  };

  config = lib.mkIf cfg.enable {
    users = {
      users = lib.optionalAttrs (cfg.user == "retrospectacle") {
        retrospectacle = {
          inherit (cfg) group;
          isSystemUser = true;
        };
      };

      groups = lib.optionalAttrs (cfg.group == "retrospectacle") { retrospectacle = { }; };
    };

    systemd.services.retrospectacle = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        Restart = "always";
        RestartSec = 20;
        Environment = "NODE_PORT=${builtins.toString cfg.port}";
        ExecStart = "${cfg.package}/bin/retrospectacle";
        AmbientCapabilities = lib.optionalString (cfg.port < 1024) "cap_net_bind_service";
      };
    };

    services.nginx = {
      enable = true;
      recommendedProxySettings = true;

      virtualHosts.${cfg.domain} = {
        enableACME = cfg.acme.enable;
        forceSSL = cfg.acme.enable;

        locations."/" = {
          proxyPass = "http://127.0.0.1:${builtins.toString cfg.port}";
          proxyWebsockets = true;
        };
      };
    };
  };
}
