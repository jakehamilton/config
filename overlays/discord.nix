{ ... }:

final: prev: {
  discord-chromium = with prev;
    makeDesktopItem {
      name = "Discord";
      desktopName = "Discord (chromium)";
      genericName = "All-in-one cross-platform voice and text chat for gamers";
      exec = ''
        ${chromium}/bin/chromium --app="https://discord.com/channels/@me" --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer --ozone-platform=wayland'';
      icon = "discord";
      type = "Application";
      categories = "Network;InstantMessaging;";
      terminal = "false";
      mimeType = "x-scheme-handler/discord";
    };
}
