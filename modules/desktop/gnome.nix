{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.desktop.gnome;
in {
  options.plusultra.desktop.gnome = with types; {
    enable =
      mkBoolOpt false "Whether or not to use Gnome as the desktop environment.";
    wallpaper = mkOpt (nullOr string) null "The wallpaper to display.";
    wayland = mkBoolOpt true "Whether or not to use Wayland.";
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
      wl-clipboard
      gnome.nautilus-python
      gnomeExtensions.appindicator
      gnomeExtensions.big-avatar
      gnomeExtensions.no-overview
      gnomeExtensions.wireless-hid
      gnomeExtensions.emoji-selector
      gnomeExtensions.clear-top-bar
      gnomeExtensions.transparent-top-bar
      gnomeExtensions.gsconnect
    ];

    # Required for app indicators
    services.udev.packages = with pkgs; [ gnome3.gnome-settings-daemon ];

    services.xserver = {
      enable = true;

      libinput.enable = true;
      displayManager.gdm = {
        enable = true;
        wayland = cfg.wayland;
      };
      desktopManager.gnome.enable = true;
    };

    plusultra.home.extraOptions = mkIf (lib.not null cfg.wallpaper) {
      dconf.settings = let
        user = config.users.users.${config.plusultra.user.name};
        wallpaper = "${user.home}/Pictures/wallpapers/${cfg.wallpaper}";
      in {
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
