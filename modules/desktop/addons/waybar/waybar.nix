{ options, config, lib, pkgs, ... }:

with lib;
let
    cfg = config.ultra.desktop.addons.waybar;
in
{
    options.ultra.desktop.addons.waybar = with types; {
        enable = mkBoolOpt false "Whether to enable Waybar in the desktop environment.";
    };

    config = mkIf cfg.enable {
        environment.systemPackages = with pkgs; [
            waybar
        ];

        ultra.home.configFile."waybar/config".source = ./config;
        ultra.home.configFile."waybar/style.css".source = ./style.css;
    };
}