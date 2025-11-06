{ inputs, channels, ... }:
let
  project = import "${inputs.tmux}/nilla.nix";
in
_final: prev: {
  tmuxPlugins = prev.tmuxPlugins // {
    inherit (channels.unstable.tmuxPlugins) vim-tmux-navigator;
  };

  plusultra = (prev.plusultra or { }) // {
    tmux = project.packages.default.result.${prev.system};
  };
}
