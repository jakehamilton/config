{ options, config, lib, pkgs, ... }:

with lib;
let
    cfg = config.plusultra.desktop.addons.nautilus;
in
{
    options.plusultra.desktop.addons.nautilus = with types; {
        enable = mkBoolOpt false "Whether to enable the gnome file manager.";
    };

    config = mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        gnome.nautilus
      ];
    };
}
