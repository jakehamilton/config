{ channels, comma, ... }:

final: prev:

{
  inherit (comma.packages.${final.system}) comma;
}
