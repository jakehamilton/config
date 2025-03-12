{ lib
, config
, pkgs
, ...
}:
let
  cfg = config.plusultra.apps.inkscape;
in
{
  options.plusultra.apps.inkscape = {
    enable = lib.mkEnableOption "Inkscape";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      inkscape-with-extensions
      google-fonts
    ];
  };
}
