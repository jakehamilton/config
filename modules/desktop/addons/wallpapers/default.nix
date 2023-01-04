{ options, config, pkgs, lib, ... }:

with lib;
let
  cfg = config.plusultra.desktop.addons.wallpapers;
  wallpapers = pkgs.plusultra.wallpapers;
in
{
  options.plusultra.desktop.addons.wallpapers = with types; {
    enable = mkBoolOpt false
      "Whether or not to add wallpapers to ~/Pictures/wallpapers.";
  };

  config = {
    plusultra.home.file = lib.foldl
      (acc: name:
        let wallpaper = wallpapers.${name};
        in
        acc // {
          "Pictures/wallpapers/${wallpaper.fileName}".source = wallpaper;
        })
      { }
      (wallpapers.names);
  };
}
