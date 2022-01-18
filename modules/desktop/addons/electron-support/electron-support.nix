{ options, config, lib, pkgs, ... }:

with lib;
let
    cfg = config.plusultra.desktop.addons.electron-support;
in
{
    options.plusultra.desktop.addons.electron-support = with types; {
        enable = mkBoolOpt false "Whether to enable electron support in the desktop environment.";
    };

    config = mkIf cfg.enable {
        plusultra.home.configFile."electron-flags.conf".source = ./electron-flags.conf;
    };
}
