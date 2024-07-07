{
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.desktop.addons.waybar;
in
{
  options.${namespace}.desktop.addons.waybar = with types; {
    enable = mkBoolOpt false "Whether to enable Waybar in the desktop environment.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ waybar ];

    plusultra.home.configFile."waybar/config".source = ./config;
    plusultra.home.configFile."waybar/style.css".source = ./style.css;
  };
}
