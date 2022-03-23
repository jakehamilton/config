{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.cli-apps.wine;
in {
  options.plusultra.cli-apps.wine = with types; {
    enable = mkBoolOpt false "Whether or not to enable Wine.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      wineUnstable
      winetricks
      wine64Packages.unstable
    ];
  };
}
