{ channels, ... }:

final: prev:

{
  inherit (channels.nixpkgs-unstable)
    neovim neovim-unwrapped neovim-remote nodePackages vimPlugins
    sumneko-lua-language-server tree-sitter gopls rust-analyzer;
}
