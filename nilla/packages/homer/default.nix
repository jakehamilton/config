{
  config.packages.homer = {
    systems = [ "x86_64-linux" ];

    package = import ./package.nix;
  };
}
