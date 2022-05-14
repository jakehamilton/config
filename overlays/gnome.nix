{ channels, ... }:

final: prev:

let extensions = channels.nixpkgs-unstable.gnomeExtensions;
in {
  gnomeExtensions = prev.gnomeExtensions // {
    inherit (extensions) audio-output-switcher;
  };
}
