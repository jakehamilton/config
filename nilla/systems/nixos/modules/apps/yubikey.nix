{ lib
, config
, pkgs
, ...
}:
let
  cfg = config.plusultra.apps.yubikey;
in
{
  options.plusultra.apps.yubikey = {
    enable = lib.mkEnableOption "Yubikey";
  };

  config = lib.mkIf cfg.enable {
    services.yubikey-agent.enable = true;
    environment.systemPackages = with pkgs; [
      # FIXME: This package is marked insecure, but I would still like to have a GUI version of the Yubikey management stuff.
      # yubikey-manager-qt
    ];
  };
}
