{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.apps.element;
in {
  options.plusultra.apps.element = with types; {
    enable = mkBoolOpt true "Whether or not to enable Element.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ element-desktop-wayland ]; };
}
