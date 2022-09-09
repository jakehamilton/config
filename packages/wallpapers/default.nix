{ pkgs, lib, ... }:

let
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

        passthru = { inherit fileName; };
      };
    in
    pkg;
  names = builtins.map (lib.snowfall.path.get-file-name-without-extension) images;
  wallpapers = lib.foldl
    (acc: image:
      let
        # fileName = builtins.baseNameOf image;
        # lib.getFileName is a helper to get the basename of
        # the file and then take the name before the file extension.
        # eg. mywallpaper.png -> mywallpaper
        name = lib.snowfall.path.get-file-name-without-extension image;
      in
      acc // { "${name}" = mkWallpaper name (./wallpapers + "/${image}"); })
    { }
    images;
  installTarget = "$out/share/wallpapers";
  installWallpapers = builtins.mapAttrs
    (name: wallpaper: ''
      cp ${wallpaper} ${installTarget}/${wallpaper.fileName}
    '')
    wallpapers;
in
pkgs.stdenvNoCC.mkDerivation {
  name = "plusultra-wallpapers";
  src = ./wallpapers;

  installPhase = ''
    mkdir -p ${installTarget}

    find * -type f -mindepth 0 -maxdepth 0 -exec cp ./{} ${installTarget}/{} ';'
  '';

  passthru = { inherit names; } // wallpapers;
}
