{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.ultra.security.keyring;
in
{
  options.ultra.security.keyring = with types; {
    enable = mkBoolOpt false "Whether to enable gnome keyring.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs.gnome; [
      gnome-keyring
      libgnome-keyring
    ];
  };
}
