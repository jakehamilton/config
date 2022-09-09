{ channels, ... }:

final: prev:

{
  inherit (channels.unstable) flyctl;
}
