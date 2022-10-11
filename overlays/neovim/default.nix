{ neovim, ... }:

final: prev: {
  plusultra = (prev.plusultra or { }) // {
    inherit (neovim.packages.${prev.system}) neovim;
  };
}
