{ channels, ... }:

final: prev:

{
  inherit (channels.nixpkgs-unstable) nordic;
}
