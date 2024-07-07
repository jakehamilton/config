{ scrumfish, ... }:

final: prev: { scrumfish = scrumfish.packages.${prev.system}.scrumfish-backend; }
