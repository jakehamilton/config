{
  pkgs,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) override-meta;

  nix-update-index = pkgs.writeShellScriptBin "nix-update-index" ''
    set -euo pipefail

    filename="index-${pkgs.system}"
    release="https://github.com/Mic92/nix-index-database/releases/latest/download/''${filename}"

    mkdir -p ~/.cache/nix-index

    pushd ~/.cache/nix-index > /dev/null

    ${pkgs.wget}/bin/wget -q -N https://github.com/Mic92/nix-index-database/releases/latest/download/$filename

    ln -f ''${filename} files

    popd > /dev/null
  '';

  new-meta = with lib; {
    description = "A helper for downloading the latest nix-index database.";
    license = licenses.asl20;
    maintainers = with maintainers; [ jakehamilton ];
  };
in
override-meta new-meta nix-update-index
