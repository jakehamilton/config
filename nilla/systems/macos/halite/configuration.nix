{
  config,
  pkgs,
  lib,
  ...
}:
{
  environment.systemPath = [
    "/opt/homebrew/bin"
    "$HOME/.bun"
  ];

  plusultra = {
    suites = {
      art.enable = true;
      common.enable = true;
      development.enable = true;
    };

    desktop.yabai.enable = true;

    home.extraOptions = {
      home.stateVersion = lib.mkForce "26.05";
    };
  };

  system.stateVersion = 7;
}
