inputs@{ lib, ... }:

final: prev:
let
  pkgs = final // inputs;
  mkPackage = name: prev.callPackage (lib.getPackagePath "/${name}") pkgs;
in {
  plusultra = {
    wallpapers = prev.callPackage (lib.getPackagePath "/wallpapers") inputs;
    firefox-nordic-theme =
      prev.callPackage (lib.getPackagePath "/firefox-nordic-theme") inputs;
    nodePackages = pkgs.stdenvNoCC.mkDerivation {
      name = "plusultra-node-packages";
      passthru = prev.callPackage (lib.getPackagePath "/node-packages") {
        pkgs = prev;
        nodejs = prev.nodejs-18_x;
      };
    };
    cowsay-plus = prev.callPackage (lib.getPackagePath "/cowsay-plus") inputs;
    nixos-revision =
      prev.callPackage (lib.getPackagePath "/nixos-revision") inputs;
    xdg-open-with-portal = mkPackage "xdg-open-with-portal";
    discord = prev.callPackage (lib.getPackagePath "/discord") (pkgs // rec {
      pname = "discord-canary";
      binaryName = "DiscordCanary";
      desktopName = "Discord";
      ffmpeg = pkgs.ffmpeg-full;
      electron = pkgs.electron_15;
      inherit (pkgs.discord-canary) src version meta;
    });
    frappe-books = mkPackage "frappe-books";
    update-nix-index = mkPackage "update-nix-index";
    doukutsu-rs = mkPackage "doukutsu-rs";
  };
}
