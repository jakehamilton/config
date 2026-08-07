{
  lib,
  config,
  pkgs,
  project,
  ...
}:

let
  cfg = config.plusultra.theme;
  inherit (project.lib.colors) base16;

  base-font = {
    name = "Hack Nerd Font Mono";
    package = pkgs.nerd-fonts.hack;
  };

  emoji-font = {
    name = "Noto Color Emoji";
    package = pkgs.noto-fonts-color-emoji;
  };
in
{
  imports = [
    project.inputs.stylix.result.darwinModules.stylix
  ];

  options.plusultra.theme = {
    enable = lib.mkOption {
      description = "Whether to automatically theme applications on this machine.";
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;
      polarity = "dark";

      fonts = {
        serif = base-font;
        sansSerif = base-font;
        monospace = base-font;
        emoji = emoji-font;
      };

      base16Scheme = base16;

      homeManagerIntegration = {
        autoImport = false;
        followSystem = true;
      };
    };
  };
}
