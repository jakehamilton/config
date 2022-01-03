{ options, config, lib, pkgs, ... }:

with lib;
  let cfg = config.ultra.desktop.sway;
in
{
  options.ultra.desktop.sway = with types; {
    enable = mkBoolOpt false "Whether or not to enable Sway.";
  };

  config = mkIf cfg.enable {
    # Desktop additions
    ultra.desktop.addons = {
      kanshi = enabled;
      waybar = enabled;
      rofi = enabled;
      electron-support = enabled;
    };

    ultra.home.configFile."sway/config".source = ./config;

    programs.sway = {
      enable = true;
      extraPackages = with pkgs; [
        rofi
        swaylock
        swayidle
        xwayland
        mako
        kitty
        grim
        slurp
        swaylock-fancy
        wl-clipboard
        wf-recorder
        (python38.withPackages (ps: with ps; [ keyring ]))
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

    # configuring sway itself (assmung a display manager starts it)
    systemd.user.targets.sway-session = {
      description = "Sway compositor session";
      documentation = [ "man:systemd.special(7)" ];
      bindsTo = [ "graphical-session.target" ];
      wants = [ "graphical-session-pre.target" ];
      after = [ "graphical-session-pre.target" ];
    };

    services.xserver.enable = true;
    services.xserver.displayManager.defaultSession = "sway";
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.libinput.enable = true;
  };
}
