{ options, config, lib, pkgs, ... }:

with lib;
let
    cfg = config.ultra.desktop.addons.nautilus;
in
{
    options.ultra.desktop.addons.nautilus = with types; {
        enable = mkBoolOpt false "Whether to enable the gnome file manager.";
    };

    config = mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        gnome.nautilus
      ];
    };
}
