inputs@{ nixpkgs, home-manager, darwin, utils, nixos-hardware, ... }:

let
  # This file is the entrypoint for the lib system and
  # needs to define a few functions itself since we can't
  # yet import the full lib.

  # Compose two functions.
  compose = f: g: x: f (g x);

  # The flipped version of `builtins.getAttr`. This function
  # gets passed the set *first* and then the attribute to access.
  getAttr' = set: attr: set.${attr};

  # Inputs comes from `flake.nix` and has a `self` property.
  # We can't use `self` in lib code since it will cause infinite
  # recursion.
  inputModules = builtins.removeAttrs inputs [ "self" ];

  # Merge two sets.
  merge = a: b: a // b;

  # Construct a new lib set given an array of sets to merge with.
  mkLib =
    (libs: nixpkgs.lib.extend (final: prev: nixpkgs.lib.foldl merge prev libs));

  # A helper for pulling out libs from flake inputs. This way we
  # can construct a single `lib` set with all of the functions from
  # any input's `lib` attribute.
  getLibs = inputs:
    (builtins.filter (builtins.hasAttr "lib")
      (builtins.map (getAttr' inputs) (builtins.attrNames inputs)));

  # Get a list of files in a directory.
  getFiles = path: (builtins.attrNames (builtins.readDir path));

  # Get a list of files in a directory that are *not* "default.nix".
  getModuleFiles =
    compose (builtins.filter (name: name != "default.nix")) getFiles;

  # Merge together libs from flake inputs.
  baseLib = mkLib (getLibs inputModules);

  # Construct our lib instance using a fixed point for self-referencing.
  # This makes it so each lib module can reference `lib` itself to get
  # access to other modules.
  lib = nixpkgs.lib.fix (self:
    let attrs = inputModules // { lib = self // baseLib; };
    in builtins.foldl' merge { }
    (builtins.map (file: import (./. + "/${file}") attrs)
      (getModuleFiles ./.)));

  # Export our lib merged with the base lib we created.
in baseLib.extend (final: prev: prev // lib)
