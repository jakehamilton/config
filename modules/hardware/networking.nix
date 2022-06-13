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

      networkmanager = enabled;
    };
  };
}
