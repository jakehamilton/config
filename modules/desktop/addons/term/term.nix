{ options, config, lib, pkgs, ... }:

with lib;
let
    cfg = config.plusultra.desktop.addons.term;
in
{
    options.plusultra.desktop.addons.term = with types; {
        enable = mkBoolOpt false "Whether to enable the gnome file manager.";
        pkg = mkOpt package pkgs.foot "The terminal to install.";
    };

    config = mkIf cfg.enable {
      environment.systemPackages = [
        cfg.pkg
      ];
    };
}
