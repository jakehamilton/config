{ lib, pkgs, ... }:

with lib.internal;
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
