{ retrospectacle, ... }:

final: prev: { retrospectacle = retrospectacle.packages.${prev.system}.retrospectacle-backend; }
