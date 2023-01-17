{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.plusultra.apps.etcher;
in
{
  options.plusultra.apps.etcher = with types; {
    enable = mkBoolOpt false "Whether or not to enable etcher.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [
        # Etcher is currently broken in nixpkgs, temporarily replaced with
        # gnome disk utility.
        # etcher
        gnome.gnome-disk-utility
      ];
  };
}
