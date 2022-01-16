{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.ultra.apps.firefox;
in
{
  options.ultra.apps.firefox = with types; {
    enable = mkBoolOpt true "Whether or not to enable Firefox.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ firefox-wayland ];
  };
}
