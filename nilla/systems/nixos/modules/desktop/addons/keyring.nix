{ lib
, config
, pkgs
, ...
}:
let
  cfg = config.plusultra.desktop.addons.keyring;
in
{
  options.plusultra.desktop.addons.keyring = {
    enable = lib.mkEnableOption "GNOME Keyring";
  };

  config = lib.mkIf cfg.enable {
    services.gnome.gnome-keyring.enable = true;

    environment.systemPackages = with pkgs; [ gnome.seahorse ];
  };
}
