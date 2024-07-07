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
  cfg = config.${namespace}.suites.music;
in
{
  options.${namespace}.suites.music = with types; {
    enable = mkBoolOpt false "Whether or not to enable music configuration.";
  };

  config = mkIf cfg.enable {
    plusultra = {
      apps = {
        ardour = enabled;
        bottles = enabled;
      };
    };
  };
}
