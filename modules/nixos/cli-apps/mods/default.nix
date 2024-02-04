{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.plusultra; let
  cfg = config.plusultra.cli-apps.mods;
in {
  options.plusultra.cli-apps.mods = with types; {
    enable = mkBoolOpt false "Whether or not to enable mods.";
  };

  config = mkIf cfg.enable {
    environment.variables = {
      # This isn't a real API key, it's `sh-` followed by 48 random characters
      OPENAI_API_KEY = "sh-0123456789abcdef0123456789abcdef0123456789abcdef";
      OPENAI_API_BASE = "http://ruby:8080";
    };

    environment.systemPackages = with pkgs; [
      mods
    ];

    plusultra.home.configFile = {
      "mods/mods.yml".source = ./mods.yml;
    };
  };
}
