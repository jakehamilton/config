{ channels, inputs, ... }:
final: prev:
let
  packages = import "${inputs.charmbracelet}/default.nix" {
    pkgs = prev;
  };
in
{
  charmbracelet = packages;
}
