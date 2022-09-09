{ channels, ... }:

final: prev:

let extensions = channels.unstable.gnomeExtensions;
in
{
  gnomeExtensions = prev.gnomeExtensions // {
    inherit (extensions) audio-output-switcher;
  };
}
