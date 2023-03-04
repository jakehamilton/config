{ channels, ... }:

final: prev: {
  inherit (channels.unstable) bibata-cursors;
}
