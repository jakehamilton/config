{ attic, ... }:

final: prev:
{
  # FIXME(jakehamilton): Attic currently requires a specific version of Rust that
  # is not on my stable channel. Replace this with the built-in overlay from the
  # Attic flake once stable has been upgraded to nixos-23.05.
  # inherit (attic.packages.${prev.system})
  #   attic
  #   attic-server
  #   attic-client
  #   attic-client-static
  #   attic-static;
}
