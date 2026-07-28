{ config }:
{
  config.packages.tmux = {
    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];

    package = { system, ... }: config.inputs.tmux.result.packages.tmux.result.${system};
  };
}
