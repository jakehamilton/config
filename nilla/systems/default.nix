{
  includes = [
    ./nixos
    ./macos
  ];

  config.modules.nilla = {
    nixos-systems = ./nixos;
    macos-systems = ./macos;
  };
}
