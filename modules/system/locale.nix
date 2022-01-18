{ options, config, pkgs, lib, ... }:

with lib;
let cfg = config.plusultra.system.locale;
in {
  options.plusultra.system.locale = with types; {
    enable = mkBoolOpt true "Whether or not to manage locale settings.";
  };

  config = mkIf cfg.enable {
    i18n.defaultLocale = "en_US.UTF-8";

    console = { keyMap = mkForce "us"; };
  };
}
