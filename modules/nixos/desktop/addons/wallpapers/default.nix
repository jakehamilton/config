{
  options,
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.desktop.addons.wallpapers;
  inherit (pkgs.plusultra) wallpapers;
in
{
  options.${namespace}.desktop.addons.wallpapers = with types; {
    enable = mkBoolOpt false "Whether or not to add wallpapers to ~/Pictures/wallpapers.";
  };

  config = {
    plusultra.home.file = lib.foldl (
      acc: name:
      let
        wallpaper = wallpapers.${name};
      in
      acc // { "Pictures/wallpapers/${wallpaper.fileName}".source = wallpaper; }
    ) { } (wallpapers.names);
  };
}
