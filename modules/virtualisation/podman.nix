{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.virtualisation.podman;
in {
  options.plusultra.virtualisation.podman = with types; {
    enable = mkBoolOpt false "Whether or not to enable Podman.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ podman-compose ];

    plusultra.home.extraOptions = {
      home.shellAliases = { "docker-compose" = "podman-compose"; };
    };

    virtualisation = {
      podman = {
        enable = cfg.enable;
        dockerCompat = true;
      };
    };
  };
}
