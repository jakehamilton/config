{ lib, config, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.plusultra.apps.expressvpn;
in
{
  options.plusultra.apps.expressvpn = {
    enable = mkEnableOption "Express VPN";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      plusultra.expressvpn
    ] ++ optionals config.plusultra.desktop.gnome.enable [
      gnomeExtensions.evpn-shell-assistant
    ];

    boot.kernelModules = [ "tun" ];

    systemd.services.expressvpn = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "network-online.target" ];

      description = "ExpressVPN Daemon";

      serviceConfig = {
        ExecStart = "${pkgs.plusultra.expressvpn}/bin/expressvpnd";
        Restart = "on-failure";
        RestartSec = 5;
      };
    };
  };
}
