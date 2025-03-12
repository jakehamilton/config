{ lib
, config
, pkgs
, ...
}:
let
  cfg = config.plusultra.apps.firefox;
in
{
  options.plusultra.apps.firefox = {
    enable = lib.mkEnableOption "Firefox";

    extraConfig = lib.mkOption {
      description = "Extra configuration for the user profile JS file.";
      type = lib.types.str;
      default = "";
    };

    userChrome = lib.mkOption {
      description = "Extra configuration for the user chrome CSS file.";
      type = lib.types.str;
      default = "";
    };

    settings = lib.mkOption {
      description = "Settings to apply to the profile.";
      type = lib.types.attrs;
      default = {
        "browser.aboutwelcome.enabled" = false;
        "browser.meta_refresh_when_inactive.disabled" = true;
        "browser.startup.homepage" = "https://hamho.me";
        "browser.bookmarks.showMobileBookmarks" = true;
        "browser.urlbar.suggest.quicksuggest.sponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.aboutConfig.showWarning" = false;
        "browser.ssb.enabled" = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    plusultra.desktop.addons.firefox-nordic-theme.enable = true;

    services.gnome.gnome-browser-connector.enable = config.plusultra.desktop.gnome.enable;

    plusultra.home = {
      file = lib.mkMerge [
        {
          ".mozilla/native-messaging-hosts/com.dannyvankooten.browserpass.json".source = "${pkgs.browserpass}/lib/mozilla/native-messaging-hosts/com.dannyvankooten.browserpass.json";
        }
        (lib.mkIf config.plusultra.desktop.gnome.enable {
          ".mozilla/native-messaging-hosts/org.gnome.chrome_gnome_shell.json".source = "${pkgs.chrome-gnome-shell}/lib/mozilla/native-messaging-hosts/org.gnome.chrome_gnome_shell.json";
        })
      ];

      extraOptions = {
        programs.firefox = {
          enable = true;

          nativeMessagingHosts = [
            pkgs.browserpass
          ] ++ lib.optional config.plusultra.desktop.gnome.enable pkgs.gnomeExtensions.gsconnect;

          profiles.${config.plusultra.user.name} = {
            inherit (cfg) extraConfig userChrome settings;
            id = 0;
            name = config.plusultra.user.name;
          };
        };
      };
    };
  };
}
