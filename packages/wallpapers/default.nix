{ pkgs, lib, ... }:

let
  # images = [ /nix/store/hash-wallpapers/<name>.<ext> ... ]
  images = lib.getFilesRec ./wallpapers;
  mkWallpaper = name: src:
    let
      fileName = builtins.baseNameOf src;
      pkg = pkgs.stdenvNoCC.mkDerivation {
        inherit name src;

        dontUnpack = true;

        installPhase = ''
          cp $src $out
        '';

        passthru = {
          inherit fileName;
        };
      };
    in pkg;

in lib.foldl (acc: image:
  let
    fileName = builtins.baseNameOf image;
    # lib.getFileName is a helper to get the basename of
    # the file and then take the name before the file extension.
    # eg. mywallpaper.png -> mywallpaper
    name = "${lib.getFileName fileName}";
  in acc // {
    "${name}" = mkWallpaper name image;
  }) { } images
