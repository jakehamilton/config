{ symlinkJoin, writeShellApplication }:

symlinkJoin {
  name = "docker-shim";
  paths = [
    (writeShellApplication {
      name = "docker-compose";
      checkPhase = "";
      text = builtins.readFile ./docker-compose.sh;
    })
    (writeShellApplication {
      name = "docker";
      checkPhase = "";
      text = builtins.readFile ./docker.sh;
    })
  ];
}
