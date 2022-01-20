{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.apps.logseq;
in {
  options.plusultra.apps.logseq = with types; {
    enable = mkBoolOpt false "Whether or not to enable logseq.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      (builtins.trace logseq.version) [ logseq ];
  };
}
