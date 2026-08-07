{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.plusultra.system.fonts;
in
{
  options.plusultra.system.fonts = {
    enable = lib.mkEnableOption "managed fonts";
    fonts = lib.mkOption {
      description = "Custom font packages to install";
      type = lib.types.listOf lib.types.package;
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    environment.variables = {
      # Enable icons in tooling since we have nerdfonts.
      LOG_ICONS = "true";
    };

    fonts.packages =
      (with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-color-emoji
        nerd-fonts.hack
      ])
      ++ cfg.fonts;
  };
}
