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
  cfg = config.${namespace}.archetypes.server;
in
{
  options.${namespace}.archetypes.server = with types; {
    enable = mkBoolOpt false "Whether or not to enable the server archetype.";
  };

  config = mkIf cfg.enable {
    plusultra = {
      suites = {
        common-slim = enabled;
      };

      cli-apps = {
        neovim = enabled;
        tmux = enabled;
      };
    };
  };
}
