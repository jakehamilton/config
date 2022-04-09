{ channels, ... }:

final: prev:

{
  inherit (channels.nixpkgs-unstable)
    neovim neovim-unwrapped neovim-remote nodePackages
    sumneko-lua-language-server tree-sitter gopls rust-analyzer;
  vimPlugins = channels.nixpkgs-unstable.vimPlugins // {
    inherit (prev.vimPlugins) lualine-nvim lualine-lsp-progress;
  };
}
