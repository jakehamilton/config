{ lib
, pkgs
, namespace
, inputs
, ...
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

  documentation.enable = false;

  environment.systemPath = [ "/opt/homebrew/bin" ];

  system.stateVersion = 5;
}
