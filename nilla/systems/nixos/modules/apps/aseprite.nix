{ lib
, config
, pkgs
, ...
}:
let
  cfg = config.plusultra.apps.aseprite;
in
{
  options.plusultra.apps.aseprite = {
    enable = lib.mkEnableOption "Aseprite";
  };

  config = lib.mkIf cfg.enable { environment.systemPackages = with pkgs; [ aseprite ]; };
}
