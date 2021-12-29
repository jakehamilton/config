inputs@{ pkgs, lib, ... }:

let
    presets = lib.map lib.getPresetPath [
    ];

    modules = lib.map lib.getModulePath [
        "git"
        "neovim"
        "vscode"
    ];
in
{
    imports = presets ++ modules;
}