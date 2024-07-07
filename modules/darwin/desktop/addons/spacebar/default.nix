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
  cfg = config.${namespace}.desktop.addons.spacebar;
in
{
  options.${namespace}.desktop.addons.spacebar = {
    enable = mkEnableOption "Spacebar";
  };

  config = mkIf cfg.enable {
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
        spacing_right = 10;

        foreground_color = "0xffeceff4";
        background_color = "0xff1d2128";

        text_font = ''"Hack Nerd Font Mono:Regular:14.0"'';
        icon_font = ''"Hack Nerd Font Mono:Regular:20.0"'';

        # Shell entries apparently break the whole bar...
        # https://github.com/cmacrae/spacebar/issues/104
        # right_shell_icon = "";
        # right_shell_command = ''"whoami"'';
        # right_shell = "on";
      };
    };
  };
}
