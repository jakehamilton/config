{ lib, runCommandNoCC, ... }:

let
  version = "1";

  src = builtins.fetchTarball {
    url = "https://github.com/jakehamilton/sokoban.app/releases/download/v${version}/sokoban.app.tar.gz";
    sha256 = "0arm36z7ff4di39qkbvfh605j00a13zcfwpbgr74srcs3gqcg077";
  };
in
runCommandNoCC "sokoban-website" { inherit src version; } ''
  ln -s $src $out 
''
