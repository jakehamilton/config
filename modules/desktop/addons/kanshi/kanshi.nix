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
        ultra.home.configFile."kanshi/config".source = ./config;

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
                ExecCondition = ''
                ${pkgs.bash}/bin/bash -c '[ -n "$WAYLAND_DISPLAY" ]'
                '';

                ExecStart = ''
                ${pkgs.kanshi}/bin/kanshi
                '';

                RestartSec = 5;
                Restart = "always";
            };
        };
    };
}
