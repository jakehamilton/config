{ options, config, lib, pkgs, ... }:

with lib;
let
    cfg = config.ultra.desktop.addons.keyring;
in
{
    options.ultra.desktop.addons.keyring = with types; {
        enable = mkBoolOpt false "Whether to enable the gnome keyring.";
    };

    config = mkIf cfg.enable {
      services.gnome.gnome-keyring.enable = true;

      environment.systemPackages = with pkgs; [
        gnome.seahorse
      ];
    };
}
