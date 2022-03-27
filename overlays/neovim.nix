{ channels, ... }:

final: prev:

{
  neovim = prev.neovim.override {
    viAlias = true;
    vimAlias = true;
  };
}
