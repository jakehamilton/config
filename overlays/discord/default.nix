{ channels, ... }:

final: prev: {
  plusultra = (prev.plusultra or { }) // {
    discord-chromium = with prev;
      makeDesktopItem {
        name = "Discord (chromium)";
        desktopName = "Discord (chromium)";
        genericName = "All-in-one cross-platform voice and text chat for gamers";
        exec = ''
          ${chromium}/bin/chromium --app="https://discord.com/channels/@me" --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer --ozone-platform=wayland'';
        icon = "discord";
        type = "Application";
        categories = [ "Network" "InstantMessaging" ];
        terminal = false;
        mimeTypes = [ "x-scheme-handler/discord" ];
      };

    discord-firefox = with prev;
      makeDesktopItem {
        name = "Discord (firefox)";
        desktopName = "Discord (firefox)";
        genericName = "All-in-one cross-platform voice and text chat for gamers";
        exec = ''
          ${firefox}/bin/firefox "https://discord.com/channels/@me?plusultra.app=true"'';
        icon = "discord";
        type = "Application";
        categories = [ "Network" "InstantMessaging" ];
        terminal = false;
        mimeTypes = [ "x-scheme-handler/discord" ];
      };
  };
}
