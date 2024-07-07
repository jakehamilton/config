{
  options,
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.hardware.storage;
in
{
  options.${namespace}.hardware.storage = with types; {
    enable = mkBoolOpt false "Whether or not to enable support for extra storage devices.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      ntfs3g
      fuseiso
    ];
  };
}
