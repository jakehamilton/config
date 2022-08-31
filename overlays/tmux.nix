{ channels, ... }:

final: prev:

{
  tmuxPlugins = prev.tmuxPlugins // {
    inherit (channels.nixpkgs-unstable.tmuxPlugins) vim-tmux-navigator;
  };
}
