{ inputs, ... }:

final: prev: {
  nilla = inputs.nilla-cli.packages.${prev.system}.nilla;
}
