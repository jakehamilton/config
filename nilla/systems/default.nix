{
  includes = [ ./nixos ];

  config.modules.nilla = {
    nixos-systems = ./nixos;
  };
}
