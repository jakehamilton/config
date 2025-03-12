{
  config.packages.discord-chromium = {
    systems = [ "x86_64-linux" ];

    package = { makeDesktopItem, chromium, ... }:
      makeDesktopItem {
        name = "Discord (chromium)";
        desktopName = "Discord (chromium)";
        genericName = "All-in-one cross-platform voice and text chat for gamers";
        exec = ''${chromium}/bin/chromium --app="https://discord.com/channels/@me" --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer --ozone-platform=wayland'';
        icon = "discord";
        type = "Application";
        categories = [
          "Network"
          "InstantMessaging"
        ];
        terminal = false;
        mimeTypes = [ "x-scheme-handler/discord" ];
      };
  };
}
