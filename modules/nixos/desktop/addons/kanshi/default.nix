{
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.desktop.addons.kanshi;
  user = config.${namespace}.user;
  home = config.users.users.${user.name}.home;
in
{
  options.${namespace}.desktop.addons.kanshi = with types; {
    enable = mkBoolOpt false "Whether to enable Kanshi in the desktop environment.";
  };

  config = mkIf cfg.enable {
    plusultra.home.configFile."kanshi/config".source = ./config;

    environment.systemPackages = with pkgs; [ kanshi ];

    # configuring kanshi
    systemd.user.services.kanshi = {
      description = "Kanshi output autoconfig ";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      environment = {
        XDG_CONFIG_HOME = "${home}/.config";
      };
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
