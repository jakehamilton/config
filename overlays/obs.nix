{ channels, ... }:

final: prev:

{
  inherit (channels.nixpkgs-unstable) wrapOBS obs-studio obs-studio-plugins;
}
