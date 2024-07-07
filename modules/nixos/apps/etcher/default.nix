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
  cfg = config.${namespace}.apps.etcher;
in
{
  options.${namespace}.apps.etcher = with types; {
    enable = mkBoolOpt false "Whether or not to enable etcher.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # Etcher is currently broken in nixpkgs, temporarily replaced with
      # gnome disk utility.
      # etcher
      gnome.gnome-disk-utility
    ];
  };
}
