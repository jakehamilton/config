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

    networking = {
      firewall = {
        trustedInterfaces = [ config.services.tailscale.interfaceName ];

        allowedUDPPorts = [ config.services.tailscale.port ];

        # Strict reverse path filtering breaks Tailscale exit node use and some subnet routing setups.
        checkReversePath = "loose";
      };
    };

  };
}
