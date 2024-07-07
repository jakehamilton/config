{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.desktop.addons.ags.bar;

  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    getExe
    ;

  bar = pkgs.runCommandNoCC "plusultra-ags-bar" { } ''
    mkdir -p $out

    cp -r ${./src}/* $out/

    rm -rf $out/css/index.css
    mkdir -p $out/css

    ${lib.getExe pkgs.sassc}/bin/sassc $out/sass/index.scss $out/css/index.css

    rm -rf $out/styles/sass
  '';
in
{
  options.${namespace}.desktop.addons.ags.bar = {
    enable = mkEnableOption "AGS Bar";

    package = mkOption {
      type = types.package;
      default = pkgs.ags;
      description = "The package to use for AGS";
    };
  };

  config = mkIf cfg.enable {
    plusultra = {
      desktop.hyprland.settings = {
        exec-once = [ "${getExe cfg.package} --config ${bar}/config.js" ];
      };
    };
  };
}
