{ channels, ... }:

final: prev:

{
  tmuxPlugins = prev.tmuxPlugins // {
    inherit (channels.unstable.tmuxPlugins) vim-tmux-navigator;
  };
}
