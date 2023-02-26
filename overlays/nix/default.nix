{ channels, ... }:

final: prev: {
  inherit (channels.unstable) nixUnstable;
}
