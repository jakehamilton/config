{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.ultra.apps.steam;
in {
  options.ultra.apps.steam = with types; {
    enable = mkBoolOpt false "Whether or not to enable support for Steam.";
  };

  config = mkIf cfg.enable {
    programs.steam.enable = true;
    programs.steam.remotePlay.openFirewall = true;

    hardware.steam-hardware.enable = true;
  };
}
