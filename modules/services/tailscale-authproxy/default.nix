{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.plusultra.services.tailscale-authproxy;
in
{
  options.plusultra.services.tailscale-authproxy = with types; {
    enable = mkBoolOpt false "Whether or not to run the Tailscale Dex AuthProxy";

    listenType = mkOpt (enum [ "unix" "tcp" ]) "unix" "The listener type";

    tcpAddress = mkOpt str "" "The address to listen on";
    socketPath = mkOpt str "" "The unix socket file to listen on";

    restrictTailnet = mkOpt (nullOr str) null "Only allow access from a single Tailnet";

    allowUnauthorized = mkOpt bool false "Whether or not to allow unauthorized machines";
    dexCallbackUrl = mkOpt str "http://127.0.0.1/dex/callback/tailscale-authproxy" "The url to use for authenticating with Dex";

    user = mkOpt str "tailscale-authproxy" "The user to run as";
    group = mkOpt str "tailscale-authproxy" "The group to run as";
  };

  config = mkIf cfg.enable {
    users = {
      users = optionalAttrs (cfg.user == "tailscale-authproxy") {
        tailscale-authproxy = {
          group = cfg.group;
          isSystemUser = true;
        };
      };

      groups = optionalAttrs (cfg.group == "tailscale-authproxy") {
        tailscale-authproxy = { };
      };
    };

    systemd.sockets.tailscale-authproxy = {
      partOf = [ "tailscale-authproxy.service" ];

      socketConfig = {
        ListenStream = "/run/tailscale-authproxy.sock";
      };
    };

    systemd.services.tailscale-authproxy = {
      after = [ "nginx.service" ];
      wants = [ "nginx.service" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;

        # Restart = "always";
        # RestartSec = 20;

        ExecStart =
          let
            args =
              [ "-listen-type=systemd" "-dex-callback-url='${cfg.dexCallbackUrl}'" ]
              ++ optional (cfg.allowUnauthorized) "-allow-unauthorized"
              ++ optional (cfg.restrictTailnet != null) "-restrict-tailnet='${cfg.restrictTailnet}'";
          in
          "${pkgs.tailscale-authproxy}/bin/tailscale-authproxy ${concatStringsSep " " args}'";
      };
    };
  };
}
