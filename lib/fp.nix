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
}
