{
  options,
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.tools.go;
in
{
  options.${namespace}.tools.go = with types; {
    enable = mkBoolOpt false "Whether or not to enable Go support.";
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [
        go
        gopls
      ];
      sessionVariables = {
        GOPATH = "$HOME/work/go";
      };
    };
  };
}
