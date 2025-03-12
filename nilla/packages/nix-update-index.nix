{
  config.packages.nix-update-index = {
    systems = [ "x86_64-linux" ];

    package = { lib, system, writeShellScriptBin, wget }:
      writeShellScriptBin "nix-update-index" ''
        set -euo pipefail

        filename="index-${system}"
        release="https://github.com/Mic92/nix-index-database/releases/latest/download/''${filename}"

        mkdir -p ~/.cache/nix-index

        pushd ~/.cache/nix-index > /dev/null

        ${wget}/bin/wget -q -N https://github.com/Mic92/nix-index-database/releases/latest/download/$filename

        ln -f ''${filename} files

        popd > /dev/null
      '';
  };
}
