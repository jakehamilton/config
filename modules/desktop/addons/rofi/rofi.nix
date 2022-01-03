{ options, config, lib, pkgs, ... }:

with lib;
let
    cfg = config.ultra.desktop.addons.rofi;
in
{
    options.ultra.desktop.addons.rofi = with types; {
        enable = mkBoolOpt false "Whether to enable Rofi in the desktop environment.";
    };

    config = mkIf cfg.enable {
        environment.systemPackages = with pkgs; [
            rofi
        ];

        ultra.home.configFile."rofi/config.rasi".source = ./config.rasi;
    };
}