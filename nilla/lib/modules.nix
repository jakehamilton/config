{ config }:
let
  inherit (config) lib;
in
{
  config.lib.modules = {
    never = _: lib.modules.when false { };
  };
}
