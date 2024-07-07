{
  lib,
  pkgs,
  config,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.tools.fup-repl;
  fup-repl = pkgs.writeShellScriptBin "fup-repl" ''
    ${pkgs.fup-repl}/bin/repl ''${@}
  '';
in
{
  options.${namespace}.tools.fup-repl = with types; {
    enable = mkBoolOpt false "Whether to enable fup-repl or not";
  };

  config = mkIf cfg.enable { environment.systemPackages = [ fup-repl ]; };
}
