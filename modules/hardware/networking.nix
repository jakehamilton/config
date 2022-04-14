{ options, config, pkgs, lib, ... }:

with lib;
let cfg = config.plusultra.hardware.networking;
in {
  options.plusultra.hardware.networking = with types; {
    enable = mkBoolOpt false "Whether or not to enable networking support";
    hosts = mkOpt attrs { }
      "An attribute set to merge with <option>networking.hosts</option>";
  };

  config = mkIf cfg.enable {

    plusultra.user.extraGroups = [ "networkmanager" ];

    networking = {
      hosts = {
        "127.0.0.1" = [ "local.test" ] ++ (cfg.hosts."127.0.0.1" or [ ]);
      } // cfg.hosts;

      # The global useDHCP flag is deprecated, therefore explicitly set to false here.
      # Per-interface useDHCP will be mandatory in the future, so this generated config
      # replicates the default behaviour.
      useDHCP = false;

      networkmanager = enabled;
    };
  };
}
