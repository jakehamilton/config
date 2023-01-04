{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.plusultra.desktop.gnome;
  gdmHome = config.users.users.gdm.home;
in
{
  options.plusultra.desktop.gnome = with types; {
    enable =
      mkBoolOpt false "Whether or not to use Gnome as the desktop environment.";
    wallpaper = {
      light = mkOpt (oneOf [ str package ]) pkgs.plusultra.wallpapers.nord-rainbow-light-nix "The light wallpaper to use.";
      dark = mkOpt (oneOf [ str package ]) pkgs.plusultra.wallpapers.nord-rainbow-dark-nix "The dark wallpaper to use.";
    };
    color-scheme = mkOpt (enum [ "light" "dark" ]) "dark" "The color scheme to use.";
    wayland = mkBoolOpt true "Whether or not to use Wayland.";
    suspend =
      mkBoolOpt true "Whether or not to suspend the machine after inactivity.";
    monitors = mkOpt (nullOr path) null "The monitors.xml file to create.";
  };

  config = mkIf cfg.enable {
    plusultra.system.xkb.enable = true;
    plusultra.desktop.addons = {
      gtk = enabled;
      wallpapers = enabled;
      electron-support = enabled;
      foot = enabled;
    };

    environment.systemPackages = with pkgs; [
      (hiPrio plusultra.xdg-open-with-portal)
      wl-clipboard
      gnome.gnome-tweaks
      gnome.nautilus-python
      gnomeExtensions.appindicator
      gnomeExtensions.big-avatar
      gnomeExtensions.no-overview
      gnomeExtensions.wireless-hid
      gnomeExtensions.emoji-selector
      gnomeExtensions.clear-top-bar
      gnomeExtensions.dash-to-dock
      gnomeExtensions.blur-my-shell
      gnomeExtensions.extension-list
      gnomeExtensions.just-perfection
      gnomeExtensions.transparent-top-bar
      gnomeExtensions.gsconnect
      gnomeExtensions.gtile
      gnomeExtensions.audio-output-switcher
    ];

    environment.gnome.excludePackages = with pkgs.gnome; [
      pkgs.gnome-tour
      epiphany
      geary
      gnome-font-viewer
      gnome-system-monitor
      gnome-maps
    ];

    systemd.tmpfiles.rules = [
      "d ${gdmHome}/.config 0711 gdm gdm"
    ] ++ (
      # "./monitors.xml" comes from ~/.config/monitors.xml when GNOME
      # display information is updated.
      lib.optional (cfg.monitors != null) "L+ ${gdmHome}/.config/monitors.xml - - - - ${cfg.monitors}"
    );

    # Required for app indicators
    services.udev.packages = with pkgs; [ gnome3.gnome-settings-daemon ];

    services.xserver = {
      enable = true;

      libinput.enable = true;
      displayManager.gdm = {
        enable = true;
        wayland = cfg.wayland;
        autoSuspend = cfg.suspend;
      };
      desktopManager.gnome.enable = true;
    };

    plusultra.home.extraOptions = {
      dconf.settings =
        let
          user = config.users.users.${config.plusultra.user.name};
          get-wallpaper = wallpaper:
            if lib.isDerivation wallpaper then
              builtins.toString wallpaper
            else
              wallpaper;
        in
        {
          "org/gnome/desktop/background" = {
            "picture-uri" = get-wallpaper cfg.wallpaper.light;
            "picture-uri-dark" = get-wallpaper cfg.wallpaper.dark;
          };
          "org/gnome/desktop/screensaver" = {
            "picture-uri" = get-wallpaper cfg.wallpaper.light;
            "picture-uri-dark" = get-wallpaper cfg.wallpaper.dark;
          };
          "org/gnome/desktop/interface" = {
            "color-scheme" = if cfg.color-scheme == "light" then "default" else "prefer-dark";
          };
        };
    };

    programs.kdeconnect = {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };

    # Open firewall for samba connections to work.
    networking.firewall.extraCommands =
      "iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns";
  };

}
