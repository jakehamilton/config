{ config }:
{
  config.packages.neovim = {
    systems = [ "x86_64-linux" "aarch64-linux" ];

    package = { system, ... }: config.inputs.neovim.result.packages.${system}.neovim;
  };
}
