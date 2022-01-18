{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.plusultra.desktop.sway;
  term = config.plusultra.desktop.addons.term;
  substitutedConfig = pkgs.substituteAll {
    src = ./config;
    term = term.pkg.pname or term.pkg.name;
  };
in {
  options.plusultra.desktop.sway = with types; {
    enable = mkBoolOpt false "Whether or not to enable Sway.";
    wallpaper = mkOpt (nullOr path) null "The wallpaper to display.";
    extraConfig =
      mkOpt str "" "Additional configuration for the Sway config file.";
  };

  config = mkIf cfg.enable {
    # Desktop additions
    plusultra.desktop.addons = {
      foot = enabled;
      mako = enabled;
      rofi = enabled;
      wofi = enabled;
      swappy = enabled;
      kanshi = enabled;
      waybar = enabled;
      keyring = enabled;
      nautilus = enabled;
      electron-support = enabled;
    };

    plusultra.home.configFile."sway/config".text =
      fileWithText substitutedConfig ''
        #############################
        #░░░░░░░░░░░░░░░░░░░░░░░░░░░#
        #░░█▀▀░█░█░█▀▀░▀█▀░█▀▀░█▄█░░#
        #░░▀▀█░░█░░▀▀█░░█░░█▀▀░█░█░░#
        #░░▀▀▀░░▀░░▀▀▀░░▀░░▀▀▀░▀░▀░░#
        #░░░░░░░░░░░░░░░░░░░░░░░░░░░#
        #############################

        # Launch services waiting for the systemd target sway-session.target
        exec "systemctl --user import-environment; systemctl --user start sway-session.target"

        # Start a user session dbus (required for things like starting
        # applications through wofi).
        exec dbus-daemon --session --address=unix:path=$XDG_RUNTIME_DIR/bus

        ${optionalString (lib.not null cfg.wallpaper) ''
          output * {
            bg ${cfg.wallpaper} fill
          }
        ''}

        ${cfg.extraConfig}
      '';

    programs.sway = {
      enable = true;
      extraPackages = with pkgs; [
        rofi
        swaylock
        swayidle
        xwayland
        kitty
        sway-contrib.grimshot
        swaylock-fancy
        wl-clipboard
        wf-recorder
        libinput
        playerctl
        brightnessctl
        glib # for gsettings
        gtk3.out # for gtk-launch
        gnome.gnome-control-center
      ];

      extraSessionCommands = ''
        export SDL_VIDEODRIVER=wayland
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
        export _JAVA_AWT_WM_NONREPARENTING=1
        export MOZ_ENABLE_WAYLAND=1
        export XDG_SESSION_TYPE=wayland
        export XDG_SESSION_DESKTOP=sway
        export XDG_CURRENT_DESKTOP=sway
      '';
    };

    environment.systemPackages = with pkgs;
      [
        (pkgs.writeTextFile {
          name = "startsway";
          destination = "/bin/startsway";
          executable = true;
          text = ''
            #! ${pkgs.bash}/bin/bash

            # Import environment variables from the login manager
            systemctl --user import-environment

            # Start Sway
            exec systemctl --user start sway.service
          '';
        })
      ];

    # configuring sway itself (assmung a display manager starts it)
    systemd.user.targets.sway-session = {
      description = "Sway compositor session";
      documentation = [ "man:systemd.special(7)" ];
      bindsTo = [ "graphical-session.target" ];
      wants = [ "graphical-session-pre.target" ];
      after = [ "graphical-session-pre.target" ];
    };

    systemd.user.services.sway = {
      description = "Sway - Wayland window manager";
      documentation = [ "man:sway(5)" ];
      bindsTo = [ "graphical-session.target" ];
      wants = [ "graphical-session-pre.target" ];
      after = [ "graphical-session-pre.target" ];
      # We explicitly unset PATH here, as we want it to be set by
      # systemctl --user import-environment in startsway
      environment.PATH = lib.mkForce null;
      serviceConfig = {
        Type = "simple";
        ExecStart = ''
          ${pkgs.dbus}/bin/dbus-run-session ${pkgs.sway}/bin/sway --debug
        '';
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    services.xserver.enable = true;
    services.xserver.displayManager.defaultSession = "sway";
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.displayManager.gdm.wayland = true;
    services.xserver.libinput.enable = true;
  };
}
