inputs@{ pkgs, lib, ... }:

let
    presets = lib.map lib.getPresetPath [
        "steam"
    ];

    modules = lib.map lib.getModulePath [
    ];
in
{
    imports = presets ++ modules;
}