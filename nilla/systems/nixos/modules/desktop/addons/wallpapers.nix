{ lib
, config
, pkgs
, project
, ...
}:
let
  cfg = config.plusultra.desktop.addons.wallpapers;

  wallpapers = project.packages.wallpapers.build.${pkgs.system};
in
{
  options.plusultra.desktop.addons.wallpapers = {
    enable = lib.mkEnableOption "adding wallpapers to ~/Pictures/wallpapers";
  };

  config = lib.mkIf cfg.enable {
    plusultra.home.file = lib.foldl
      (
        acc: name:
          let
            wallpaper = wallpapers.${name};
          in
          acc // { "Pictures/wallpapers/${wallpaper.fileName}".source = wallpaper; }
      )
      { }
      (wallpapers.names);
  };
}
