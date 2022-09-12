{ neovim, ... }:

final: prev: {
  plusultra = prev.plusultra // {
    inherit (neovim.packages.${prev.system}) neovim;
  };
}
