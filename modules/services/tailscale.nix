{ lib, pkgs, config, ... }:

with lib;
let cfg = config.plusultra.services.tailscale;
in {
  options.plusultra.services.tailscale = with types; {
    enable = mkBoolOpt false "Whether or not to configure Tailscale";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ tailscale ];

    services.tailscale = enabled;

    networking.firewall = {
      trustedInterfaces = [ config.services.tailscale.interfaceName ];

      allowedUDPPorts = [ config.services.tailscale.port ];
    };
  };
}
