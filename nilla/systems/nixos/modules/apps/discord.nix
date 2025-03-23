{ lib
, config
, pkgs
, project
, ...
}:
let
  cfg = config.plusultra.apps.discord;
in
{
  options.plusultra.apps.discord = {
    enable = lib.mkEnableOption "Discord";
    canary = lib.mkEnableOption "Discord Canary";
    chromium = lib.mkEnableOption "Discord Chromium";
  };

  config = {
    environment.systemPackages =
      lib.optional cfg.enable pkgs.discord
      ++ lib.optional cfg.canary pkgs.discord-canary
      ++ lib.optional cfg.chromium project.packages.discord-chromium.result.${pkgs.system};
  };
}
