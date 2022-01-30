{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.plusultra.apps.firefox;
  defaultSettings = {
    "browser.startup.homepage" =
      "https://start.duckduckgo.com/?kak=-1&kal=-1&kao=-1&kaq=-1&kt=Hack+Nerd+Font&kae=d&ks=m&k7=2e3440&kj=3b4252&k9=eceff4&kaa=d8dee9&ku=1&k8=d8dee9&kx=81a1c1&k21=3b4252&k18=1&k5=2&kp=-2&k1=-1&kaj=u&kay=b&kk=-1&kax=-1&kap=-1&kau=-1";
    "browser.bookmarks.showMobileBookmarks" = true;
    "browser.urlbar.suggest.quicksuggest.sponsored" = false;
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
    "browser.aboutConfig.showWarning" = false;
  };
in {
  options.plusultra.apps.firefox = with types; {
    enable = mkBoolOpt false "Whether or not to enable Firefox.";
    extraConfig =
      mkOpt str "" "Extra configuration for the user profile JS file.";
    userChrome =
      mkOpt str "" "Extra configuration for the user chrome CSS file.";
    settings = mkOpt attrs defaultSettings "Settings to apply to the profile.";
  };

  config = mkIf cfg.enable {
    plusultra.desktop.addons.firefox-nordic-theme = enabled;

    plusultra.home.extraOptions = {
      programs.firefox = {
        enable = true;
        package = pkgs.firefox-wayland;

        profiles.${config.plusultra.user.name} = {
          inherit (cfg) extraConfig userChrome settings;
          id = 0;
          name = config.plusultra.user.name;
        };
      };
    };
  };
}
