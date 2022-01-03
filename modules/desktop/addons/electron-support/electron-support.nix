{ options, config, lib, pkgs, ... }:

with lib;
let
    cfg = config.ultra.desktop.addons.electron-support;
in
{
    options.ultra.desktop.addons.electron-support = with types; {
        enable = mkBoolOpt false "Whether to enable electron support in the desktop environment.";
    };

    config = mkIf cfg.enable {
        ultra.home.configFile."electron-flags.conf".source = ./electron-flags.conf;
    };
}