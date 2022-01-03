{ options, config, lib, pkgs, ... }:

with lib;
let
    cfg = config.ultra.desktop.addons.kanshi;
    user = config.ultra.user;
    home = config.users.users.${user.name}.home;
in
{
    options.ultra.desktop.addons.kanshi = with types; {
        enable = mkBoolOpt false "Whether to enable Kanshi in the desktop environment.";
    };

    config = mkIf cfg.enable {
        environment.systemPackages = with pkgs; [
            kanshi
        ];

        # configuring kanshi
        systemd.user.services.kanshi = {
            description = "Kanshi output autoconfig ";
            wantedBy = [ "graphical-session.target" ];
            partOf = [ "graphical-session.target" ];
            environment = { XDG_CONFIG_HOME = "${home}/.config"; };
            serviceConfig = {
                # kanshi doesn't have an option to specifiy config file yet, so it looks
                # at .config/kanshi/config
                ExecStart = ''
                ${pkgs.kanshi}/bin/kanshi
                '';
                RestartSec = 5;
                Restart = "always";
            };
        };
    };
}