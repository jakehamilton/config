{ lib, config, ... }:
let
  cfg = config.plusultra.hardware.networking;
in
{
  options.plusultra.hardware.networking = {
    enable = lib.mkEnableOption "networking support";

    hosts = lib.mkOption {
      description = "Additional hosts to add to /etc/hosts";
      type = lib.types.attrs;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    plusultra.user.extraGroups = [ "networkmanager" ];

    networking = {
      hosts = {
        "127.0.0.1" = [ "local.test" ] ++ (cfg.hosts."127.0.0.1" or [ ]);
      } // cfg.hosts;

      networkmanager = {
        enable = true;
        dhcp = "internal";
      };
    };

    # Fixes an issue that normally causes nixos-rebuild to fail.
    # https://github.com/NixOS/nixpkgs/issues/180175
    systemd.services.NetworkManager-wait-online.enable = false;
  };
}
