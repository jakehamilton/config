{
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.desktop.addons.electron-support;
in
{
  options.${namespace}.desktop.addons.electron-support = with types; {
    enable = mkBoolOpt false "Whether to enable electron support in the desktop environment.";
  };

  config = mkIf cfg.enable {
    plusultra.home.configFile."electron-flags.conf".source = ./electron-flags.conf;

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };
}
