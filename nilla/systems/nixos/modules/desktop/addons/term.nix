{ lib
, config
, pkgs
, ...
}:
let
  cfg = config.plusultra.desktop.addons.term;
in
{
  options.plusultra.desktop.addons.term = {
    enable = lib.mkEnableOption "Default terminal";

    package = lib.mkOption {
      description = "The terminal emulator to use";
      type = lib.types.package;
      default = pkgs.foot;
    };
  };

  config = lib.mkIf cfg.enable { environment.systemPackages = [ cfg.package ]; };
}
