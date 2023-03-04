{ channels, ... }:

final: prev: {
  gnomeExtensions = prev.gnomeExtensions // {
    inherit (channels.unstable.gnomeExtensions) top-bar-organizer;
  };
}
