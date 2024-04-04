{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.plusultra; let
  cfg = config.plusultra.suites.art;
in {
  options.plusultra.suites.art = with types; {
    enable = mkBoolOpt false "Whether or not to enable art configuration.";
  };

  config = mkIf cfg.enable {
    plusultra = {
      apps = {
        gimp = enabled;
        inkscape = enabled;
        blender = enabled;
      };

      system.fonts.fonts = with pkgs; [
        google-fonts
      ];
    };
  };
}
