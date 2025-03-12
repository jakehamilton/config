{ inputs, ... }:

final: prev: {
  nilla = inputs.nilla-cli.nilla.config.packages.nilla.build.${prev.system};
}
