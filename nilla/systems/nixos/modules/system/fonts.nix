{ lib, config, pkgs, project, ... }:
let
  cfg = config.plusultra.system.fonts;
in
{
  options.plusultra.system.fonts = {
    enable = lib.mkEnableOption "fonts";

    fonts = lib.mkOption {
      description = "Custom font packages to install.";
      type = lib.types.listOf lib.types.package;
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    environment.variables = {
      # Enable icons in tooling since we have nerdfonts.
      LOG_ICONS = "true";
    };

    environment.systemPackages = with pkgs; [ font-manager ];

    fonts.packages =
      cfg.fonts
      ++ (with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-emoji
        nerd-fonts.hack
      ]);
  };
}
