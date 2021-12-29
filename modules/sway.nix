inputs@{ lib, pkgs, config, ... }:

{
  # configuring sway itself (assmung a display manager starts it)
  systemd.user.targets.sway-session = {
    description = "Sway compositor session";
    documentation = [ "man:systemd.special(7)" ];
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
  };

  environment.systemPackages = with pkgs; [
    i3pystatus
    (python38.withPackages (ps: with ps; [ i3pystatus keyring ]))
  ];

  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [
      dmenu
      swaylock
      swayidle
      xwayland
      mako
      kanshi
      grim
      slurp
      wl-clipboard
      wf-recorder
      (python38.withPackages (ps: with ps; [ i3pystatus keyring ]))
    ];
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_ENABLE_WAYLAND=1
    '';
  };

  # configuring kanshi
  systemd.user.services.kanshi = {
    description = "Kanshi output autoconfig ";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    environment = { XDG_CONFIG_HOME = "/home/mschwaig/.config"; };
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

  services.xserver.enable = true;
  services.xserver.displayManager.defaultSession = "sway";
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.libinput.enable = true;
}
