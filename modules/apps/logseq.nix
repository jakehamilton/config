{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.apps.logseq;
in {
  options.plusultra.apps.logseq = with types; {
    enable = mkBoolOpt false "Whether or not to enable logseq.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [
        # @NOTE(jakehamilton): Logseq doesn't render properly
        # on Wayland by default. We need to pass two params
        # to make it render correctly.
        (logseq.overrideAttrs (oldAttrs: {
          buildInputs = oldAttrs.buildInputs or [ ] ++ [ pkgs.makeWrapper ];

          postFixup = oldAttrs.postFixup or "" + ''
            wrapProgram $out/bin/logseq \
              --add-flags "--enable-features=UseOzonePlatform" \
              --add-flags "--ozone-platform=wayland"
          '';
        }))
      ];
  };
}
