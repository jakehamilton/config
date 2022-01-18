{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.apps.firefox;
in {
  options.plusultra.apps.firefox = with types; {
    enable = mkBoolOpt true "Whether or not to enable Firefox.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ firefox-wayland ];
  };
}
