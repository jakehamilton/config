inputs@{ lib, ... }:

{
  # Equality check.
  is = x: y: x == y;

  # Inequality check.
  not = x: y: x != y;

  # Logical OR. The equivalent of using the || operator.
  or = x: y: x || y;

  # An extension of `or` to accept two functions. `or'` returns
  # a function that is applied to both given functions and the
  # results are compared with a logical OR.
  or' = f: g: x: lib.or (f x) (g x);

  # Logical AND. The equivalent of using the || operator.
  and = x: y: x && y;

  # An extension of `or` to accept two functions. `or'` returns
  # a function that is applied to both given functions and the
  # results are compared with a logical AND.
  and' = f: g: x: lib.and (f x) (g x);
}
