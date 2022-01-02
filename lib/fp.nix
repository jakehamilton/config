inputs@{ lib, ... }:

rec {
  # Identity. Does nothing but return its argument.
  id = x: x;

  # Creates a function that returns the given value.
  only = x: _: x;

  # Compose two functions.
  compose = f: g: x: f (g x);

  # Compose functions from left to right.
  pipeAll = lib.foldl compose id;

  # Compose functions from right to left.
  composeAll = lib.foldr compose id;

  # Invert a function with two arguments.
  flip2 = f: a: b: f b a;
  # Invert a function with three arguments.
  flip3 = f: a: b: c: f c b a;
  # Invert a function with three arguments.
  flip4 = f: a: b: c: d: f d c b a;

  # Call a function with an argument.
  call = f: x: f x;

  # The inverse of `call`. Given an argument, call the next
  # function provided with it.
  apply = flip2 call;

  # Map from builtins provided for ease of use with map'.
  map = builtins.map;

  # The inverse of `map`. Given a list, map it with the next
  # function provided.
  map' = flip2 map;

  # Map a Set's attributes and return a list of the results.
  mapAttrsToList = f: attrs:
    let names = builtins.attrNames attrs; in
    map' names (name: f name attrs.${name});

  # The inverse of mapAttrsToList
  mapAttrsToList' = flip2 mapAttrsToList;

  # Map a Set's attributes and return a flattened list of the results.
  mapConcatAttrsToList = f: attrs:
    lib.flatten (mapAttrsToList f attrs);

  # The inverse of `mapConcatAttrsToList`.
  mapConcatAttrsToList' = flip2 mapConcatAttrsToList;
}
