{ options, config, lib, pkgs, ... }:
with lib;
let cfg = config.plusultra.suites.media;
in {
  options.plusultra.suites.media = with types; {
    enable = mkBoolOpt false "Whether or not to enable media configuration.";
  };

  config = mkIf cfg.enable { plusultra = { apps = { freetube = enabled; }; }; };
}
