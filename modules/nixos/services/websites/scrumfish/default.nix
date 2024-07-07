{
  lib,
  pkgs,
  config,
  namespace,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    fetchFromGitHub
    optionalString
    optionalAttrs
    ;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.services.websites.scrumfish;
in
{
  options.${namespace}.services.websites.scrumfish = with lib.types; {
    enable = mkEnableOption "Scrumfish";
    package = mkOpt package pkgs.scrumfish "The package to use.";
    domain = mkOpt str "scrumfi.sh" "The domain to serve the website site on.";

    acme = {
      enable = mkOpt bool true "Whether or not to automatically fetch and configure SSL certs.";
    };

    user = mkOpt str "scrumfish" "The user to run the app as.";
    group = mkOpt str "scrumfish" "The group to run the app as.";

    port = mkOpt port 6902 "The port to listen on.";
  };

  config = mkIf cfg.enable {
    users = {
      users = optionalAttrs (cfg.user == "scrumfish") {
        scrumfish = {
          inherit (cfg) group;
          isSystemUser = true;
        };
      };

      groups = optionalAttrs (cfg.group == "scrumfish") { scrumfish = { }; };
    };

    systemd.services.scrumfish = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        Restart = "always";
        RestartSec = 20;
        Environment = "NODE_PORT=${builtins.toString cfg.port}";
        ExecStart = "${cfg.package}/bin/scrumfish";
        AmbientCapabilities = optionalString (cfg.port < 1024) "cap_net_bind_service";
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
