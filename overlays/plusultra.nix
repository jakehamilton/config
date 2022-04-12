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
    nodePackages = prev.callPackage (lib.getPackagePath "/node-packages") {
      pkgs = prev;
      nodejs = prev.nodejs-17_x;
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
  };
}
