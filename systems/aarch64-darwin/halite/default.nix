{
  lib,
  pkgs,
  namespace,
  ...
}:
with lib.${namespace};
{
  plusultra = {
    suites = {
      common = enabled;
      development = enabled;
    };

    desktop.yabai = enabled;
  };

  environment.systemPath = [ "/opt/homebrew/bin" ];

  system.stateVersion = 4;
}
