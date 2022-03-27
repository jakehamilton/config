{ pkgs, lib, ... }:

pkgs.writeShellScriptBin "nixos-revision" ''
  echo $(nixos-version --json | ${pkgs.jq}/bin/jq -r .configurationRevision)
''
