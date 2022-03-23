{ channels, ... }:

final: prev:

{
  inherit (channels.nixpkgs-unstable) linuxPackages_latest;
}
