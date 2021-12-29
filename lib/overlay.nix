inputs@{ lib, ... }:

rec {
    mkOverlays = names: channels:
        lib.map
        (name: import (lib.getOverlayPath name) (inputs // { inherit channels; }))
        names;
}