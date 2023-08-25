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

  environment.systemPath = [
    "/opt/homebrew/bin"
  ];

  system.stateVersion = 4;
}
