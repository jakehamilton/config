{
  lib,
  writeText,
  writeShellApplication,
  substituteAll,
  gum,
  inputs,
  hosts ? { },
  namespace,
  ...
}:
let
  inherit (lib) mapAttrsToList concatStringsSep;
  inherit (lib.${namespace}) override-meta;

  substitute = args: builtins.readFile (substituteAll args);

  formatted-hosts = mapAttrsToList (name: host: "${name},${host.pkgs.system}") hosts;

  hosts-csv = writeText "hosts.csv" ''
    Name,System
    ${concatStringsSep "\n" formatted-hosts}
  '';

  nixos-hosts = writeShellApplication {
    name = "nixos-hosts";

    text = substitute {
      src = ./nixos-hosts.sh;

      help = ./help;
      hosts = if hosts == { } then "" else hosts-csv;
    };

    checkPhase = "";

    runtimeInputs = [ gum ];
  };

  new-meta = with lib; {
    description = "A helper to list all of the NixOS hosts available from your flake.";
    license = licenses.asl20;
    maintainers = with maintainers; [ jakehamilton ];
  };
in
override-meta new-meta nixos-hosts
