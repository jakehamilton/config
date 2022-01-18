inputs@{ lib, ... }:

rec {
  mkOverlays = { src ? ../overlays }:
    channels:
    let overlays = lib.getModuleFilesWithoutDefaultRec src;
    in lib.map' overlays
    (overlay: import overlay (inputs // { inherit channels; }));
}
