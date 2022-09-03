{ config, lib, pkgs, ... }:

with lib;
let
  # Usage:
  # mkVimConfig ./some-file.vim {
  #   MY_ARG = "hello-world";
  # }
  mkVimConfig = file: args:
    let module =
      pkgs.substituteAll (args // {
        src = file;
      });
    in
    "source ${module}";

  # Usage:
  # mkVimConfigs [
  #   ./some-file.vim
  #   { file = ./some-other.vim; options = { MY_ARG = "hello-world"; }; }
  # ]
  mkVimConfigs = files:
    lib.concatMapStringsSep "\n"
      (file:
        if builtins.isAttrs file then
          mkVimConfig file.file file.options
        else
          mkVimConfig file { }
      )
      files;
in
mkVimConfigs [
  ./init.vim
]

