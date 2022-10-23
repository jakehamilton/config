{ channels, ... }:

final: prev:

{
  inherit (channels.unstable) firefox-wayland;
}
