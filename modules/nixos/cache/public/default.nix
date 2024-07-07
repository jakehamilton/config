{
  config,
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.cache.public;
in
{
  options.${namespace}.cache.public = {
    enable = mkEnableOption "Plus Ultra public cache";
  };

  config = mkIf cfg.enable {
    plusultra.nix.extra-substituters = {
      "https://attic.ruby.hamho.me/public".key = "public:QUkZTErD8fx9HQ64kuuEUZHO9tXNzws7chV8qy/KLUk=";
    };
  };
}
