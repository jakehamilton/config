inputs@{ pkgs, lib, ... }:

let
  presets = lib.map lib.getPresetPath [ ];

  modules = lib.map lib.getModulePath [ "discord" "1password" ];
in { imports = presets ++ modules; }
