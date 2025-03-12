{ lib, config, ... }:
let
  cfg = config.plusultra.system.locale;
in
{
  options.plusultra.system.locale = {
    enable = lib.mkEnableOption "locale configuration";
  };

  config = lib.mkIf cfg.enable {
    i18n.defaultLocale = "en_US.UTF-8";

    console = {
      keyMap = lib.mkForce "us";
    };
  };
}
