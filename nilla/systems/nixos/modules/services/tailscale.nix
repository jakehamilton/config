{ lib, config, pkgs, ... }:
let
  cfg = config.plusultra.services.tailscale;
in
{
  options.plusultra.services.tailscale = {
    enable = lib.mkEnableOption "Tailscale";

    autoconnect = {
      enable = lib.mkEnableOption "automatic connection to Tailscale";
      key = lib.mkOption {
        description = "The authentication key to use.";
        type = lib.types.str;
        default = "";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.autoconnect.enable -> cfg.autoconnect.key != "";
        message = "plusultra.services.tailscale.autoconnect.key must be set";
      }
    ];

    environment.systemPackages = with pkgs; [ tailscale ];

    services.tailscale.enable = true;

    networking = {
      firewall = {
        trustedInterfaces = [ config.services.tailscale.interfaceName ];

        allowedUDPPorts = [ config.services.tailscale.port ];

        # Strict reverse path filtering breaks Tailscale exit node use and some subnet routing setups.
        checkReversePath = "loose";
      };

      networkmanager.unmanaged = [ "tailscale0" ];
    };

    systemd.services.tailscale-autoconnect = lib.mkIf cfg.autoconnect.enable {
      description = "Automatic connection to Tailscale";

      # Make sure tailscale is running before trying to connect to tailscale
      after = [
        "network-pre.target"
        "tailscale.service"
      ];
      wants = [
        "network-pre.target"
        "tailscale.service"
      ];
      wantedBy = [ "multi-user.target" ];

      # Set this service as a oneshot job
      serviceConfig.Type = "oneshot";

      # Have the job run this shell script
      script = ''
        # Wait for tailscaled to settle
        sleep 2

        # Check if we are already authenticated to tailscale
        status="$(${pkgs.tailscale}/bin/tailscale status -json | ${pkgs.jq}/bin/jq -r .BackendState)"
        if [ $status = "Running" ]; then # if so, then do nothing
          exit 0
        fi

        # Otherwise authenticate with tailscale
        ${pkgs.tailscale}/bin/tailscale up -authkey "${cfg.autoconnect.key}"
      '';
    };
  };
}
