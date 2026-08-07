{ lib, config }:
let
  inherit (config) inputs;
in
{
  options.systems = {
    macos = lib.options.create {
      description = "macos systems to create.";
      default.value = { };
      type = lib.types.attrs.of (
        lib.types.submodule (
          { config }:
          {
            options = {
              args = lib.options.create {
                description = "Additional arguments to pass to system modules.";
                type = lib.types.attrs.any;
                default.value = { };
              };

              pkgs = lib.options.create {
                description = "The Nixpkgs instance to use.";
                type = lib.types.raw;
                default.value =
                  if inputs ? nixpkgs && inputs.nixpkgs.result ? x86_64-linux then
                    inputs.nixpkgs.result.x86_64-linux
                  else
                    null;
              };

              darwin = lib.options.create {
                description = "The Nix Darwin input to use.";
                type = lib.types.raw;
                default.value = if inputs ? nix-darwin then inputs.nix-darwin.result else null;
              };

              modules = lib.options.create {
                description = "A list of modules to use for the system.";
                type = lib.types.list.of lib.types.raw;
                default.value = [ ];
              };

              result = lib.options.create {
                description = "The created macos system.";
                type = lib.types.raw;
                writable = false;
                default.value = config.darwin.lib.darwinSystem {
                  pkgs = config.pkgs;
                  lib = config.pkgs.lib;
                  specialArgs = config.args;
                  modules = config.modules;
                };
              };
            };
          }
        )
      );
    };
  };

  config = {
    assertions = lib.lists.flatten (
      lib.attrs.mapToList (name: value: [
        {
          assertion = !(builtins.isNull value.pkgs);
          message = "A Nixpkgs instance is required for the macos system \"${name}\", but none was provided and \"inputs.nixpkgs\" does not exist.";
        }
        {
          assertion = !(builtins.isNull value.darwin);
          message = "A Nix Darwin input is required for the macos system \"${name}\", but none was provided and \"inputs.nix-darwin\" does not exist.";
        }
      ]) config.systems.macos
    );
  };
}
