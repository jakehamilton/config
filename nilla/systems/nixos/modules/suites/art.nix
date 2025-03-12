{ lib
, config
, pkgs
, ...
}:
let
  cfg = config.plusultra.suites.art;
in
{
  options.plusultra.suites.art = {
    enable = lib.mkEnableOption "the art suite";
  };

  config = lib.mkIf cfg.enable {
    plusultra = {
      apps = {
        inkscape.enable = true;
        blender.enable = true;
        aseprite.enable = true;
      };

      system.fonts.fonts = with pkgs; [ google-fonts ];
    };
  };
}
