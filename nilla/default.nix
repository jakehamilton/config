{
  includes = [
    ./colmena
    ./explain
    ./lib
    ./packages
    ./systems
  ];

  config.modules.nilla = {
    colmena = ./colmena;
    explain = ./explain;
    lib = ./lib;
    packages = ./packages;
    systems = ./systems;
  };
}
