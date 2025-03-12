{ config }:
{
  config.packages.nixos-hosts = {
    systems = [ "x86_64-linux" ];

    package = import ./package.nix;

    settings = {
      args = {
        hosts = config.systems.nixos;
      };
    };
  };
}
