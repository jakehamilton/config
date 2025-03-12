{
  config.packages.titan = {
    systems = [ "x86_64-linux" ];

    package = import ./package.nix;
  };
}
