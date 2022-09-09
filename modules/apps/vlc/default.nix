{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.apps.vlc;
in {
  options.plusultra.apps.vlc = with types; {
    enable = mkBoolOpt false "Whether or not to enable vlc.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ vlc ]; };
}
