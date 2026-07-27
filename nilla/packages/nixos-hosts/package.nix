{ lib
, writeText
, writeShellApplication
, replaceVars
, gum
, hosts ? { }
, ...
}:
let
  inherit (lib) mapAttrsToList concatStringsSep;

  substitute = args: builtins.readFile (replaceVars args.src (builtins.removeAttrs args [ "src" ]));

  formatted-hosts = mapAttrsToList (name: host: "${name},${host.result.pkgs.system}") hosts;

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
in
nixos-hosts
