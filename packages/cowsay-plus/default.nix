{ pkgs, lib, ... }:

let
  cowfiles = pkgs.fetchFromGitHub {
    owner = "paulkaefer";
    repo = "cowsay-files";
    rev = "277057be8adefce94d3aac291bcbf719646c5da5";
    sha256 = "1g7v7d2jfjw7hm5mqa40f1nqvis41zkr0nwwqs8hmjglz6kcv23x";
    name = "cowsay-files";
  };
in pkgs.writeShellScriptBin "cowsay-plus" ''
  COWS=(${cowfiles}/cows/*.cow)
  TOTAL_COWS=$(ls ${cowfiles}/cows/*.cow | wc -l)

  RAND_COW=$(($RANDOM % $TOTAL_COWS))

  ${pkgs.cowsay}/bin/cowsay -f ''${COWS[$RAND_COW]} $@
''
