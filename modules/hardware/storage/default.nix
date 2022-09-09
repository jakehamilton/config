{ options, config, pkgs, lib, ... }:

with lib;
let cfg = config.plusultra.hardware.storage;
in {
  options.plusultra.hardware.storage = with types; {
    enable = mkBoolOpt false
      "Whether or not to enable support for extra storage devices.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ ntfs3g fuseiso ];
  };
}
