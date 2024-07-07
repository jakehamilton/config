{
  lib,
  nixos-option,
  makeWrapper,
  fetchFromGitHub,
  runCommandNoCC,
  flakeSource ? "/home/short/work/config",
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) override-meta;

  flake-compat = fetchFromGitHub {
    owner = "edolstra";
    repo = "flake-compat";
    rev = "b4a34015c698c7793d592d66adbab377907a2be8";
    sha256 = "1qc703yg0babixi6wshn5wm2kgl5y1drcswgszh4xxzbrwkk9sv7";
  };
  prefix = ''(import ${flake-compat} { src = ${flakeSource}; }).defaultNix.nixosConfigurations.\$(hostname)'';

  new-meta = with lib; {
    description = "A wrapper around nixos-option to work with a Flake-based configuration.";
    license = licenses.asl20;
    maintainers = with maintainers; [ jakehamilton ];
  };

  package = runCommandNoCC "nixos-option" { buildInputs = [ makeWrapper ]; } ''
    makeWrapper ${nixos-option}/bin/nixos-option $out/bin/nixos-option \
      --add-flags --config_expr \
      --add-flags "\"${prefix}.config\"" \
      --add-flags --options_expr \
      --add-flags "\"${prefix}.options\""
  '';
in
override-meta new-meta package
