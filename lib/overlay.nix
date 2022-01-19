inputs@{ lib, utils, ... }:

rec {
  mkOverlays = { src ? ../overlays }:
    channels:
    let overlays = lib.getModuleFilesWithoutDefaultRec src;
    in [ utils.overlay ] ++ lib.map' overlays
    (overlay: import overlay (inputs // { inherit channels; }));
}
