{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.plusultra.desktop.gnome;
  drv = pkgs.stdenv.mkDerivation {
    name = "hello";
    src = ./.;
    installPhase = ''
      mkdir $out
      echo "hello" > $out/message.txt
    '';
  };
in {
  options.plusultra.desktop.gnome = with types; {
    enable =
      mkBoolOpt false "Whether or not to use Gnome as the desktop environment.";
    wallpaper = mkOpt (nullOr string) null "The wallpaper to display.";
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
      gnomeExtensions.appindicator
      gnomeExtensions.big-avatar
      gnomeExtensions.no-overview
      gnomeExtensions.wireless-hid
      gnomeExtensions.emoji-selector
      gnomeExtensions.clear-top-bar
      gnomeExtensions.transparent-top-bar
    ];

    # Required for app indicators
    services.udev.packages = with pkgs; [ gnome3.gnome-settings-daemon ];

    services.xserver = {
      enable = true;

      libinput.enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };

    plusultra.home.file."hello-world".source = "${drv}/message.txt";

    plusultra.home.extraOptions = mkIf (lib.not null cfg.wallpaper) {
      dconf.settings = let
        user = config.users.users.${config.plusultra.user.name};
        wallpaper = "${user.home}/Pictures/wallpapers/${cfg.wallpaper}";
      in {
        "org/gnome/desktop/background" = { "picture-uri" = wallpaper; };
        "org/gnome/desktop/screensaver" = { "picture-uri" = wallpaper; };
      };
    };
  };

}
