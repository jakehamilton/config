inputs@{ lib, ... }:

{
  is = x: y: x == y;
  not = x: y: x != y;
}
