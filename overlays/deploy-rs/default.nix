{ channels, ... }:

final: prev:

{
  inherit (channels.unstable) deploy-rs;
}
