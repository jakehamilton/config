{ lib
, config
, pkgs
, ...
}:
let
  cfg = config.plusultra.apps.bottles;
in
{
  options.plusultra.apps.bottles = {
    enable = lib.mkEnableOption "Bottles";
  };

  config = lib.mkIf cfg.enable { environment.systemPackages = with pkgs; [ bottles ]; };
}
