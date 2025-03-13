{ host ? builtins.throw "No host name provided...", ... }:
{
  imports = [
    ./boot.nix
    ./env.nix
    ./fonts.nix
    ./locale.nix
    ./time.nix
    ./xkb.nix
    ./zfs.nix
  ];

  config = {
    networking.hostName = host;
  };
}
