{
  lib,
  config,
  pkgs,
  project,
  ...
}:
let
  cfg = config.plusultra.desktop.addons.spacebar;

  inherit (project.lib) colors;

  foreground = colors.without-hash colors.bliss.text;
  background = colors.without-hash colors.bliss.surface-dark;
  primary = colors.without-hash colors.bliss.sakura;
in
{
  options.plusultra.desktop.addons.spacebar = {
    enable = lib.mkEnableOption "Spacebar";
  };

  config = lib.mkIf cfg.enable {
    services.spacebar = {
      enable = true;
      package = pkgs.spacebar;

      config = {
        position = "top";
        display = "all";
        height = 32;
        title = "on";
        spaces = "on";
        clock = "on";
        power = "off";

        padding_left = 10;
        padding_right = 10;

        spacing_left = 10;
        spacing_rightn = 10;

        foreground_color = "0xff${foreground}";
        background_color = "0xff${background}";
        space_icon_color = "0xff${primary}";

        text_font = ''"Hack Nerd Font Mono:Regular:14.0"'';
        icon_font = ''"Hack Nerd Font Mono:Regular:20.0"'';
      };
    };
  };
}
