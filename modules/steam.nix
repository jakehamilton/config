inputs@{ lib, pkgs, nixpkgs, ... }:

{
  programs.steam.enable = true;
  programs.steam.remotePlay.openFirewall = true;
}
