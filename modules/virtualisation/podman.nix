{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.virtualisation.podman;
in {
  options.plusultra.virtualisation.podman = with types; {
    enable = mkBoolOpt false "Whether or not to enable Podman.";
  };

  config = mkIf cfg.enable {
    virtualisation = {
      podman = {
        enable = cfg.enable;
        dockerCompat = true;
      };
    };
  };
}
