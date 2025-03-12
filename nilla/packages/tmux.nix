{ config }:
{
  config.packages.tmux = {
    systems = [ "x86_64-linux" "aarch64-linux" ];

    package = { system, ... }: config.inputs.tmux.loaded.packages.${system}.tmux;
  };
}
