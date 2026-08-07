{ config }:
{
  config.packages.neovim = {
    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];

    package = { system, ... }: config.inputs.neovim.result.packages.neovim.result.${system};
  };
}
