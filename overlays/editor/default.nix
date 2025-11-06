{ inputs, ... }:
let
  project = import "${inputs.editor}/nilla.nix";
in
_final: prev: {
  plusultra = (prev.plusultra or { }) // {
    neovim = project.packages.default.result.${prev.system};
  };
}
