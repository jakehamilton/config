{ lib, pkgs, ... }:

with lib.plusultra;
{
  plusultra = {
    suites = {
      common = enabled;
      development = enabled;
    };
  };

  environment.systemPath = [
    "/opt/homebrew/bin"
  ];

  system.stateVersion = 4;
}
