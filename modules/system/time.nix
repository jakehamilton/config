{ options, config, pkgs, lib, ... }:

with lib;
let cfg = config.plusultra.system.time;
in {
  options.plusultra.system.time = with types; {
    enable = mkBoolOpt false "Whether or not to configure timezone information.";
  };

  config = mkIf cfg.enable { time.timeZone = "America/Los_Angeles"; };
}
