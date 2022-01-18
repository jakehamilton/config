{ pkgs, lib, ... }:

let
  # images = [ /nix/store/hash-wallpapers/<name>.<ext> ... ]
  images = builtins.attrNames (builtins.readDir ./wallpapers);
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

in {
  names = lib.map (lib.getFileName) images;
} // lib.foldl (acc: image:
  let
    # fileName = builtins.baseNameOf image;
    # lib.getFileName is a helper to get the basename of
    # the file and then take the name before the file extension.
    # eg. mywallpaper.png -> mywallpaper
    name = lib.getFileName image;
  in acc // {
    "${name}" = mkWallpaper name (./wallpapers + "/${image}");
  }) { } images
