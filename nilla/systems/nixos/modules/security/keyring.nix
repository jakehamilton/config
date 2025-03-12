{ lib, config, pkgs, ... }:
let
  cfg = config.plusultra.security.keyring;
in
{
  options.plusultra.security.keyring = {
    enable = lib.mkEnableOption "GNOME Keyring";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gnome-keyring
      libgnome-keyring
    ];
  };
}
