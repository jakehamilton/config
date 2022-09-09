{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.plusultra.apps.discord;
  discord = pkgs.discord-plugged.override {
    plugins = [
      (pkgs.fetchFromGitHub {
        owner = "NurMarvin";
        repo = "discord-tweaks";
        rev = "bc28b090f9ed706d7f8271aeaa64bdcb886fd0ef";
        sha256 = "0mrqshgdzh324qh00gb57fxdpnnm5xw8idckslrfbr5hrqzxnb65";
      })
    ];
    themes = [
      (pkgs.fetchFromGitHub {
        owner = "DapperCore";
        repo = "NordCord";
        rev = "c5f2c61da6abeffc1b2ecfb6fc6d99736a8286bf";
        sha256 = "1nz3prxvjghbrpdyswkgfiph79h6n3rsyp1ar9j56rg8hr5yaqpn";
      })
    ];
  };
in {
  options.plusultra.apps.discord = with types; {
    enable = mkBoolOpt false "Whether or not to enable Discord.";
    canary.enable = mkBoolOpt false "Whether or not to enable Discord Canary.";
    chromium.enable = mkBoolOpt false
      "Whether or not to enable the Chromium version of Discord.";
    firefox.enable = mkBoolOpt false
      "Whether or not to enable the Firefox version of Discord.";
  };

  config = mkIf (cfg.enable or cfg.chromium.enable) {
    environment.systemPackages = lib.optional cfg.enable discord
      ++ lib.optional cfg.canary.enable (pkgs.plusultra.discord)
      ++ lib.optional cfg.chromium.enable pkgs.discord-chromium
      ++ lib.optional cfg.firefox.enable pkgs.discord-firefox;
  };
}
