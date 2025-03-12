{ lib
, config
, pkgs
, ...
}:
let
  cfg = config.plusultra.hardware.storage;
in
{
  options.plusultra.hardware.storage = {
    enable = lib.mkEnableOption "support for storage devices";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      ntfs3g
      fuseiso
    ];
  };
}
