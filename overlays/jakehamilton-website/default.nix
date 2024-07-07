{ jakehamilton-website, ... }:

final: prev: { jakehamilton-website = jakehamilton-website.packages.${prev.system}.website; }
