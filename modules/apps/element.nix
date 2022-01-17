{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.ultra.apps.element;
in {
  options.ultra.apps.element = with types; {
    enable = mkBoolOpt true "Whether or not to enable Element.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ element-desktop-wayland ]; };
}
