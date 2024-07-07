{ snowfall-docs, ... }:
final: prev: {
  snowfallorg = (prev.snowfallorg or { }) // {
    inherit (snowfall-docs.packages.${prev.system}) snowfall-docs;
  };
}
