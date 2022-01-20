{ channels, ... }:

final: prev:

{
  # The version in unstable appears to be broken right now.
  # Uncomment this when it is fixed.
  # inherit (channels.nixpkgs-unstable) logseq;
}
