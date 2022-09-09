{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.apps.inkscape;
in {
  options.plusultra.apps.inkscape = with types; {
    enable = mkBoolOpt false "Whether or not to enable Inkscape.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ inkscape-with-extensions google-fonts ];
  };
}
