{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.apps.discord;
in {
  options.plusultra.apps.discord = with types; {
    enable = mkBoolOpt false "Whether or not to enable Discord.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
        # @NOTE(jakehamilton): Code doesn't render properly
        # on Wayland by default. We need to pass two params
        # to make it render correctly.
        #
        # Also, this doesn't seem to actually work :(
        (discord.overrideAttrs (oldAttrs: {
          buildInputs = oldAttrs.buildInputs or [ ] ++ [ pkgs.makeWrapper ];

          installPhase = oldAttrs.installPhase or "" + ''
            wrapProgram $out/bin/discord \
              --add-flags "--enable-features=UseOzonePlatform" \
              --add-flags "--ozone-platform=wayland"
          '';
        }))
        discord-chromium
    ];
  };
}
