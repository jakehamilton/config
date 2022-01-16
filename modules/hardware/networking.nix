{ options, config, pkgs, lib, ... }:

with lib;
let cfg = config.ultra.hardware.networking;
in {
  options.ultra.hardware.networking = with types; {
    enable = mkBoolOpt true "Whether or not to enable networking support.";
  };

  config = mkIf cfg.enable {
    networking.networkmanager.enable = true;

    ultra.user.extraGroups = [ "networkmanager" ];

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    networking.useDHCP = false;
  };
}
