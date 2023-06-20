{ lib
, writeText
, writeShellApplication
, substituteAll
, gum
, inputs
, hosts ? { }
, ...
}:

let
  inherit (lib) mapAttrsToList concatStringsSep;

  substitute = args: builtins.readFile (substituteAll args);

  formatted-hosts = mapAttrsToList
    (name: host: "${name},${host.pkgs.system}")
    hosts;

  hosts-csv = writeText "hosts.csv" ''
    Name,System
    ${concatStringsSep "\n" formatted-hosts}
  '';
in
writeShellApplication
{
  name = "nixos-hosts";

  text = substitute {
    src = ./nixos-hosts.sh;

    help = ./help;
    hosts = if hosts == { } then "" else hosts-csv;
  };

  checkPhase = "";

  runtimeInputs = [
    gum
  ];
}
