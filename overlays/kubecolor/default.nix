{ channels, ... }:

final: prev:

{
  inherit (channels.unstable) kubecolor;
}
