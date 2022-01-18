{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.security.keyring;
in {
  options.plusultra.security.keyring = with types; {
    enable = mkBoolOpt false "Whether to enable gnome keyring.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs.gnome; [
      gnome-keyring
      libgnome-keyring
    ];
  };
}
