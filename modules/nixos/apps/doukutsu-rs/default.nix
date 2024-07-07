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
  cfg = config.${namespace}.apps.doukutsu-rs;
  desktopItem = pkgs.makeDesktopItem {
    name = "doukutsu-rs";
    desktopName = "doukutsu-rs";
    genericName = "A fully playable re-implementation of Cave Story (Doukutsu Monogatari) engine written in Rust.";
    exec = "${pkgs.plusultra.doukutsu-rs}/bin/doukutsu-rs";
    icon = ./icon.png;
    type = "Application";
    categories = [
      "Game"
      "AdventureGame"
    ];
    terminal = false;
  };
in
{
  options.${namespace}.apps.doukutsu-rs = with types; {
    enable = mkBoolOpt false "Whether or not to enable doukutsu-rs.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs.plusultra; [
      doukutsu-rs
      desktopItem
    ];
  };
}
