{
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.suites.art;
in
{
  options.${namespace}.suites.art = with types; {
    enable = mkBoolOpt false "Whether or not to enable art configuration.";
  };

  config = mkIf cfg.enable {
    plusultra = {
      apps = {
        gimp = enabled;
        inkscape = enabled;
        blender = enabled;
      };

      system.fonts.fonts = with pkgs; [ google-fonts ];
    };
  };
}
