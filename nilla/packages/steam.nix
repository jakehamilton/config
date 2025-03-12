{
  config.packages.steam = {
    systems = [ "x86_64-linux" ];

    package = { makeDesktopItem, symlinkJoin, ... }:
      let
        steam-pipewire = makeDesktopItem {
          name = "Steam (Pipewire)";
          desktopName = "Steam (Pipewire)";
          genericName = "Application for managing and playing games on Steam.";
          categories = [
            "Network"
            "FileTransfer"
            "Game"
          ];
          type = "Application";
          icon = "steam";
          exec = "steam -pipewire";
          terminal = false;
        };
        steam-pipewire-gamepadui = makeDesktopItem {
          name = "Steam (Pipewire & Gamepad UI)";
          desktopName = "Steam (Pipewire & Gamepad UI)";
          genericName = "Application for managing and playing games on Steam.";
          categories = [
            "Network"
            "FileTransfer"
            "Game"
          ];
          type = "Application";
          icon = "steam";
          exec = "steam -pipewire -gamepadui";
          terminal = false;
        };

        package = symlinkJoin {
          name = "steam-desktop-items";
          paths = [
            steam-pipewire
            steam-pipewire-gamepadui
          ];
        };
      in
      package;
  };
}
