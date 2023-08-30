{ lib, pkgs, ... }:

with lib.plusultra;
{
  plusultra = {
    suites = {
      common = enabled;
      development = enabled;
    };

    desktop.yabai = enabled;
  };

  environment.variables = {
    CLOUDSDK_PYTHON = "${pkgs.python}/bin/python";
  };

  environment.systemPath = [
    "/opt/homebrew/bin"
  ];

  system.stateVersion = 4;
}
