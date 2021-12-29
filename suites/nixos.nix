inputs@{ pkgs, lib, ... }:

let
    presets = lib.map lib.getPresetPath [
        "nix"
        "boot"
        "locale"
        "networking"
        "audio"
        "fonts"
    ];

    modules = lib.map lib.getModulePath [
        "utils"
        "firefox"
    ];
in
{
    imports = presets ++ modules;
}