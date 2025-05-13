{
  includes = [
    ./colmena
    ./explain
    ./lib
    ./packages
    ./systems

    ./inputs.nix
  ];

  config.modules.nilla = {
    colmena = ./colmena;
    explain = ./explain;
    lib = ./lib;
    packages = ./packages;
    systems = ./systems;
  };
}
