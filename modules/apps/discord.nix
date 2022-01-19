{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.apps.discord;
in {
  options.plusultra.apps.discord = with types; {
    enable = mkBoolOpt false "Whether or not to enable Discord.";
    chromium.enable = mkBoolOpt false
      "Whether or not to enable the Chromium version of Discord.";
  };

  config = mkIf (cfg.enable or cfg.chromium.enable) {
    environment.systemPackages = with pkgs;
    # @NOTE(jakehamilton): Code doesn't render properly
    # on Wayland by default. We need to pass two params
    # to make it render correctly.
    #
    # Also, this doesn't seem to actually work :(
      lib.optional cfg.enable (discord.overrideAttrs (oldAttrs: {
        buildInputs = oldAttrs.buildInputs or [ ] ++ [ pkgs.makeWrapper ];

        installPhase = oldAttrs.installPhase or "" + ''
          wrapProgram $out/bin/discord \
            --add-flags "--enable-features=UseOzonePlatform,WebRTCPipeWireCapturer" \
            --add-flags "--ozone-platform=wayland"
        '';
      })) ++ lib.optional cfg.chromium.enable discord-chromium;
  };
}
