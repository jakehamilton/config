{ lib, nixos-option, makeWrapper, fetchFromGitHub, runCommandNoCC, flakeSource ? "/home/short/work/config", ... }:

let
  flake-compat = fetchFromGitHub {
    owner = "edolstra";
    repo = "flake-compat";
    rev = "b4a34015c698c7793d592d66adbab377907a2be8";
    sha256 = "1qc703yg0babixi6wshn5wm2kgl5y1drcswgszh4xxzbrwkk9sv7";
  };
  prefix = ''(import ${flake-compat} { src = ${flakeSource}; }).defaultNix.nixosConfigurations.\$(hostname)'';
in
runCommandNoCC "nixos-option"
{
  buildInputs = [ makeWrapper ];
}
  ''
    makeWrapper ${nixos-option}/bin/nixos-option $out/bin/nixos-option \
      --add-flags --config_expr \
      --add-flags "\"${prefix}.config\"" \
      --add-flags --options_expr \
      --add-flags "\"${prefix}.options\""
  ''
