{ makeDesktopItem, firefox, ... }:

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
}
