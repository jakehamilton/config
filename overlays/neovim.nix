{ channels, ... }:

final: prev:

{
  vimPlugins = prev.vimPlugins // {
    inherit (channels.nixpkgs-unstable.vimPlugins) nord-nvim dashboard-nvim vim-tmux-navigator;
  };
}
