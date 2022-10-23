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
    wallpaper = mkOpt (nullOr string) null "The wallpaper to display.";
    wayland = mkBoolOpt true "Whether or not to use Wayland.";
    suspend =
      mkBoolOpt true "Whether or not to suspend the machine after inactivity.";
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
    ];

    systemd.tmpfiles.rules = [
      "d ${gdmHome}/.config 0711 gdm gdm"
      # "./monitors.xml" comes from ~/.config/monitors.xml when GNOME
      # display information is updated.
      "L+ ${gdmHome}/.config/monitors.xml - - - - ${./monitors.xml}"
    ];

    # Required for app indicators
    services.udev.packages = with pkgs; [ gnome3.gnome-settings-daemon ];

    # Browser integration
    services.gnome.chrome-gnome-shell.enable = true;

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

    plusultra.home.extraOptions = mkIf (cfg.wallpaper != null) {
      dconf.settings =
        let
          user = config.users.users.${config.plusultra.user.name};
          wallpaper = "${user.home}/Pictures/wallpapers/${cfg.wallpaper}";
        in
        {
          "org/gnome/desktop/background" = { "picture-uri" = wallpaper; };
          "org/gnome/desktop/screensaver" = { "picture-uri" = wallpaper; };
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
