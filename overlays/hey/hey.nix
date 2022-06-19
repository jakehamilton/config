{ channels, ... }:

final: prev: {
  hey = prev.makeDesktopItem {
    name = "HEY";
    desktopName = "HEY";
    genericName = "The email app that makes email suck less.";
    exec = ''
      ${final.firefox}/bin/firefox "https://app.hey.com/?plusultra.app=true"'';
    icon = ./icon.svg;
    type = "Application";
    categories = [ "Office" "Network" "Email" ];
    terminal = false;
  };
}
