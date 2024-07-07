{
  lib,
  pkgs,
  config,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.desktop.addons.skhd;

  mkScript =
    name: file:
    pkgs.writeShellApplication {
      inherit name;
      checkPhase = "";
      text = builtins.readFile file;
    };

  open-iterm2 = mkScript "open-iterm2" ./scripts/open-iterm2.sh;
in
{
  options.${namespace}.desktop.addons.skhd = {
    enable = mkEnableOption "skhd";
  };

  config = mkIf cfg.enable {
    services.skhd = {
      enable = true;

      skhdConfig = ''
        # Movement
        shift + cmd - h : yabai -m window --focus west
        shift + cmd - j : yabai -m window --focus south
        shift + cmd - k : yabai -m window --focus north
        shift + cmd - l : yabai -m window --focus east

        # Window Movement
        lctrl + shift + cmd - h : yabai -m window --swap west
        lctrl + shift + cmd - j : yabai -m window --swap south
        lctrl + shift + cmd - k : yabai -m window --swap north
        lctrl + shift + cmd - l : yabai -m window --swap east

        # Window Resize
        lctrl + cmd - h : yabai -m window --resize left:-50:0; \
                          yabai -m window --resize right:-50:0
        lctrl + cmd - j : yabai -m window --resize bottom:0:50; \
                          yabai -m window --resize top:0:50
        lctrl + cmd - k : yabai -m window --resize top:0:-50; \
                          yabai -m window --resize bottom:0:-50
        lctrl + cmd - l : yabai -m window --resize right:50:0; \
                          yabai -m window --resize left:50:0

        lctrl + alt - h : yabai -m window --resize left:-10:0; \
                    yabai -m window --resize right:-10:0
        lctrl + alt - j : yabai -m window --resize bottom:0:10; \
                    yabai -m window --resize top:0:10
        lctrl + alt - k : yabai -m window --resize top:0:-10; \
                    yabai -m window --resize bottom:0:-10
        lctrl + alt - l : yabai -m window --resize right:10:0; \
                          yabai -m window --resize left:10:0

        lctrl + cmd - e : yabai -m space --balance

        # Move Window To Space
        lctrl + shift + cmd - m : yabai -m window --space last; yabai -m space --focus last
        lctrl + shift + cmd - p : yabai -m window --space prev; yabai -m space --focus prev
        lctrl + shift + cmd - n : yabai -m window --space next; yabai -m space --focus next
        lctrl + shift + cmd - 1 : yabai -m window --space 1; yabai -m space --focus 1
        lctrl + shift + cmd - 2 : yabai -m window --space 2; yabai -m space --focus 2
        lctrl + shift + cmd - 3 : yabai -m window --space 3; yabai -m space --focus 3
        lctrl + shift + cmd - 4 : yabai -m window --space 4; yabai -m space --focus 4

        # Focus Space
        # shift + cmd - m : yabai -m space --focus last
        # shift + cmd - p : yabai -m space --focus prev
        # shift + cmd - n : yabai -m space --focus next
        shift + cmd - 1 : yabai -m space --focus 1
        shift + cmd - 2 : yabai -m space --focus 2
        shift + cmd - 3 : yabai -m space --focus 3
        shift + cmd - 4 : yabai -m space --focus 4

        # Insert Direction
        lctrl + shift + cmd - v : yabai -m window --insert south
        lctrl + shift + cmd - b : yabai -m window --insert east
        lctrl + shift + cmd - s : yabai -m window --insert stack

        # Floating Windows
        # shift + cmd - space : \
        #   yabai -m window --toggle float; \
        #   yabai -m window --toggle border
        shift + cmd - space : yabai -m window --toggle float

        # Terminal
        shift + cmd - return : ${open-iterm2}/bin/open-iterm2

        # Fullscreen
        alt - f : yabai -m window --toggle zoom-fullscreen
        shift + alt - f : yabai -m window --toggle native-fullscreen

        # Restart Yabai
        shift + lctrl + alt - r : \
          /usr/bin/env osascript <<< \
            "display notification \"Restarting Yabai\" with title \"Yabai\""; \
          launchctl kickstart -k "gui/$UID/org.nixos.yabai"

        # Restart Spacebar
        shift + lctrl + alt - s : \
          /usr/bin/env osascript <<< \
            "display notification \"Restarting Spacebar\" with title \"Spacebar\""; \
          launchctl kickstart -k "gui/$UID/org.nixos.spacebar"
      '';
    };
  };
}
