{ channels, ... }:

final: prev: {
  twitter = prev.makeDesktopItem {
    name = "Twitter";
    desktopName = "Twitter";
    genericName = "The toxic bird app.";
    exec = ''
      ${final.firefox}/bin/firefox "https://twitter.com/home?plusultra.app=true"'';
    icon = ./icon.svg;
    type = "Application";
    categories = [ "Network" "InstantMessaging" "Feed" ];
    terminal = false;
  };
}
