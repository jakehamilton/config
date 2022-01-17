{ pkgs, lib, ... }:

let
  images = lib.getFilesRec ./wallpapers;
in
  lib.foldl (acc: image:
    let name = lib.getFileName (builtins.baseNameOf image);
    in acc // {
      "${name}" = image;
    }
  ) {} images
