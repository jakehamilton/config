inputs@{ lib, ... }:

rec {
  # mkOverlays = names: channels:
  #   lib.map
  #   (name: import (lib.getOverlayPath name) (inputs // { inherit channels; }))
  #   names;

  mkOverlays = { src ? ../overlays }: channels:
    let
      overlays = lib.getModuleFilesWithoutDefaultRec src;
    in
      lib.map'
        overlays
        (overlay:
          import overlay (inputs // { inherit channels; })
        );
}
