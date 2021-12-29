inputs@{ pkgs, lib, ... }:

let
    presets = lib.map lib.getPresetPath [
        "gnome"
    ];

    modules = lib.map lib.getModulePath [
    ];
in
{
    imports = presets ++ modules;
}