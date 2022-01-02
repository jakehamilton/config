{ channels, lib, ... }:

final: prev:
let
  steam = prev.steamPackages.steam.overrideAttrs (oldAttrs: {
    postInstall = oldAttrs.postInstall or "" + ''
      substituteInPlace steam.desktop \
        --replace "Exec=steam" "Exec=env GDK_SCALE=2 steam"
    '';
  });

in {
  steamPackages = prev.steamPackages // { inherit steam; };
}
