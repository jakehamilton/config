# Taken and modified from https://kevincox.ca/2022/12/09/valheim-server-nixos-v2/
{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.services.steam;
in
{
  options.${namespace}.services.steam = {
    enable = lib.mkEnableOption "Steam";
  };

  config = lib.mkIf cfg.enable {
    users.users.steamcmd = {
      isSystemUser = true;
      group = config.users.groups.steamcmd.name;
      home = "/var/lib/steamcmd";
      homeMode = "777";
      createHome = true;
    };

    users.groups.steamcmd = { };

    systemd.services."steamcmd@" = {
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${
          pkgs.resholve.writeScript "steam"
            {
              interpreter = "${pkgs.zsh}/bin/zsh";
              inputs = with pkgs; [
                patchelf
                steamcmd
                coreutils
              ];
              execer = [ "cannot:${pkgs.steamcmd}/bin/steamcmd" ];
            }
            ''
              set -eux

              instance=''${1:?Instance Missing}
              eval 'args=(''${(@s:_:)instance})'
              app=''${args[1]:?App ID missing}
              beta=''${args[2]:-}
              betapass=''${args[3]:-}

              dir=/var/lib/steamcmd/apps/$instance

              cmds=(
                +force_install_dir $dir
                +login anonymous
                +app_update $app validate
              )

              if [[ $beta ]]; then
                cmds+=(-beta $beta)
                if [[ $betapass ]]; then
                  cmds+=(-betapassword $betapass)
                fi
              fi

              cmds+=(+quit)

              steamcmd $cmds

              for f in $dir/*; do
                set +e
                chmod -R ugo+rwx $f
                set -e

                if ! [[ -f $f && -x $f ]]; then
                  continue
                fi

                # Update the interpreter to the path on NixOS.
                patchelf --set-interpreter ${pkgs.glibc}/lib/ld-linux-x86-64.so.2 $f || true
              done
            ''
        } %i";
        PrivateTmp = true;
        Restart = "on-failure";
        StateDirectory = "steamcmd/apps/%i";
        TimeoutStartSec = 3600; # Allow time for updates.
        User = config.users.users.steamcmd.name;
        WorkingDirectory = "~";
      };
    };

    # Some games might depend on the Steamworks SDK redistributable, so download it.
    systemd.services.steamworks-sdk = {
      wantedBy = [ "multi-user.target" ];
      wants = [
        "steamcmd@1007.service"
        "steamworks-sdk.timer"
      ];
      after = [ "steamcmd@1007.service" ];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = lib.escapeShellArgs [
          "${pkgs.coreutils}/bin/echo"
          "Done! Steamworks SDK should be downloaded now."
        ];
        Restart = "no";
        User = config.users.users.steamcmd.name;
        WorkingDirectory = "~";
      };
    };

    systemd.timers.steamworks-sdk = {
      description = "Updates Steamworks SDK daily.";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        Unit = "steamworks-sdk.service";
        OnCalendar = "*-*-* 04:00:00";
        Persistent = true;
      };
    };
  };
}
