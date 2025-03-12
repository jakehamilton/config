{ config }:
{
  config.packages.wallpapers = {
    systems = [ "x86_64-linux" ];

    package = import ./package.nix;

    settings = {
      args = {
        lib' = config.lib;
      };
    };
  };
}
