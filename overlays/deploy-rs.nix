{ channels, ... }:

final: prev:

{
  inherit (channels.nixpkgs-unstable) deploy-rs;
}
