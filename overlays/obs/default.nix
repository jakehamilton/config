{ channels, ... }:

final: prev:

{
  inherit (channels.unstable) wrapOBS obs-studio obs-studio-plugins;
}
