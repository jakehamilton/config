{ channels, ... }:

final: prev: {
  inherit (channels.unstable) gamescope;
}
