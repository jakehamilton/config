{ lib, config, pkgs, host ? null, format ? "unknown", ... }:

let
  inherit (lib) types;
  inherit (lib.internal) mkOpt;
in
{
  options.plusultra.host = {
    name = mkOpt (types.nullOr types.str) host "The host name.";
  };
}
