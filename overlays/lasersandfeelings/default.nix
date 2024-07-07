{ lasersandfeelings, ... }:

final: prev: { inherit (lasersandfeelings.packages.${prev.system}) lasersandfeelings; }
