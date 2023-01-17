{ lib, makeDesktopItem, firefox, ... }:

let
  with-meta = lib.internal.override-meta {
    platforms = lib.platforms.linux;
    broken = firefox.meta.broken;
  };

  twitter =
    makeDesktopItem {
      name = "Twitter";
      desktopName = "Twitter";
      genericName = "The toxic bird app.";
      exec = ''
        ${firefox}/bin/firefox "https://twitter.com/home?plusultra.app=true"'';
      icon = ./icon.svg;
      type = "Application";
      categories = [ "Network" "InstantMessaging" "Feed" ];
      terminal = false;
    };
in
with-meta twitter
