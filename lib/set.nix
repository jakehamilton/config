inputs@{ lib, ... }:

rec {
  # Merge two sets.
  merge = x: y: x // y;

  # The inverse of `merge`.
  merge' = lib.flip2 merge;

  # This comes directly from `builtins` to make it easier to refer to.
  getAttr = builtins.getAttr;

  # The flipped version of `builtins.getAttr`. This function
  # gets passed the set *first* and then the attribute to access.
  getAttr' = lib.flip2 builtins.getAttr;

  # Map the attribute names of a set. Returns a list of the results.
  mapAttrNames = fn: attrs: builtins.map fn (builtins.attrNames attrs);
}
